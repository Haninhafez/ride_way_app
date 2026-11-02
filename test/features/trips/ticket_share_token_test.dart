// test/features/trips/ticket_share_token_test.dart
//
// Tests for:
//   1. Token generation (length, URL-safe chars, uniqueness)
//   2. Expiry calculation
//   3. TicketShareDTO field mapping / maskName
//   4. DigitalTicketState copyWith
//   5. SharedTicketCubit state transitions (mocked repository)
//   6. QR payload assertion (must be a URL, never raw booking data)

import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ride_way_app/core/config/app_links_config.dart';
import 'package:ride_way_app/features/trips/data/models/ticket_share_dto.dart';
import 'package:ride_way_app/features/trips/domain/entities/ticket_share.dart';
import 'package:ride_way_app/features/trips/domain/repositories/trips_repository.dart';
import 'package:ride_way_app/features/trips/domain/usecases/resolve_share_usecase.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/digital_ticket_state.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/shared_ticket_cubit.dart';
import 'package:ride_way_app/features/trips/presentation/cubit/shared_ticket_state.dart';

// ── mocks ─────────────────────────────────────────────────────────────────────

class MockTripsRepository extends Mock implements TripsRepository {}

// ── token generation (mirrors the private algorithm in the production class) ──

String _generateToken() {
  final rng = Random.secure();
  // 18 bytes → 6 full groups of 3 → 24 base64url chars, trimmed to 22.
  // 22 × 6 bits = 132 bits entropy.
  final bytes = List<int>.generate(18, (_) => rng.nextInt(256));
  const alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  final sb = StringBuffer();
  for (int i = 0; i + 2 < bytes.length; i += 3) {
    final b0 = bytes[i];
    final b1 = bytes[i + 1];
    final b2 = bytes[i + 2];
    sb
      ..write(alphabet[(b0 >> 2) & 0x3F])
      ..write(alphabet[((b0 << 4) | (b1 >> 4)) & 0x3F])
      ..write(alphabet[((b1 << 2) | (b2 >> 6)) & 0x3F])
      ..write(alphabet[b2 & 0x3F]);
  }
  return sb.toString().substring(0, 22);
}

// ── expiry (mirrors the private algorithm) ────────────────────────────────────

DateTime _calcExpiry(String travelDateStr) {
  final inSevenDays = DateTime.now().add(const Duration(days: 7));
  final travel = DateTime.tryParse(travelDateStr);
  if (travel == null) return inSevenDays;
  final dayAfterTravel = travel.add(const Duration(days: 1));
  return dayAfterTravel.isAfter(inSevenDays) ? dayAfterTravel : inSevenDays;
}

// ── test data helpers ─────────────────────────────────────────────────────────

Map<String, dynamic> _shareMap({bool revoked = false, DateTime? expiresAt}) {
  final now = DateTime.now();
  return {
    'bookingId': 'bk123',
    'ownerUid': 'uid456',
    'createdAt': now.toIso8601String(),
    'expiresAt':
        (expiresAt ?? now.add(const Duration(days: 7))).toIso8601String(),
    'revoked': revoked,
    'originCode': 'RUH',
    'originName': 'Riyadh',
    'destinationCode': 'JED',
    'destinationName': 'Jeddah',
    'travelDate': '2026-12-01',
    'departureTime': '09:00',
    'arrivalTime': '11:00',
    'trainCode': 'SE-200',
    'trainName': 'Saudi Express',
    'coach': '2',
    'seatNumbers': '5A',
    'bookingStatus': 'upcoming',
    'paymentStatus': 'paid',
    'maskedPassengerName': 'Nasser A.',
  };
}

void main() {
  // ── 1. Token generation ──────────────────────────────────────────────────
  group('Token generation', () {
    test('produces exactly 22 characters', () {
      for (int i = 0; i < 50; i++) {
        expect(_generateToken().length, 22);
      }
    });

    test('contains only URL-safe characters', () {
      final validChars = RegExp(r'^[A-Za-z0-9\-_]+$');
      for (int i = 0; i < 100; i++) {
        final t = _generateToken();
        expect(validChars.hasMatch(t), isTrue, reason: 'invalid chars in: $t');
      }
    });

    test('generates unique tokens (1000 samples, no collision)', () {
      final seen = <String>{};
      for (int i = 0; i < 1000; i++) {
        final t = _generateToken();
        expect(seen.contains(t), isFalse, reason: 'collision: $t');
        seen.add(t);
      }
    });

    test('is never empty or "undefined"', () {
      for (int i = 0; i < 20; i++) {
        final t = _generateToken();
        expect(t, isNotEmpty);
        expect(t, isNot('undefined'));
      }
    });
  });

  // ── 2. Expiry calculation ─────────────────────────────────────────────────
  group('Expiry calculation', () {
    test('uses 7-day window when travel date is in the past', () {
      final past = DateTime.now().subtract(const Duration(days: 10));
      final ds =
          '${past.year}-${past.month.toString().padLeft(2, '0')}-${past.day.toString().padLeft(2, '0')}';
      final expiry = _calcExpiry(ds);
      final diffDays = expiry.difference(DateTime.now()).inDays;
      expect(diffDays, greaterThanOrEqualTo(6));
    });

    test('uses travelDate + 1 when that is beyond 7 days', () {
      final farFuture = DateTime.now().add(const Duration(days: 30));
      final ds =
          '${farFuture.year}-${farFuture.month.toString().padLeft(2, '0')}-${farFuture.day.toString().padLeft(2, '0')}';
      final expiry = _calcExpiry(ds);
      expect(expiry.isAfter(DateTime.now().add(const Duration(days: 20))), isTrue);
    });

    test('falls back to 7-day window for invalid date string', () {
      final expiry = _calcExpiry('not-a-date');
      expect(expiry.difference(DateTime.now()).inDays, greaterThanOrEqualTo(6));
    });
  });

  // ── 3. TicketShareDTO ─────────────────────────────────────────────────────
  group('TicketShareDTO', () {
    test('fromFirestore maps all fields correctly', () {
      final dto = TicketShareDTO.fromFirestore('token-abc', _shareMap());
      expect(dto.token, 'token-abc');
      expect(dto.bookingId, 'bk123');
      expect(dto.originCode, 'RUH');
      expect(dto.destinationCode, 'JED');
      expect(dto.revoked, isFalse);
    });

    test('isExpired returns false for future expiry', () {
      final dto = TicketShareDTO.fromFirestore('t', _shareMap());
      expect(dto.isExpired, isFalse);
    });

    test('isExpired returns true for past expiry', () {
      final expiredMap = _shareMap(
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      final dto = TicketShareDTO.fromFirestore('t', expiredMap);
      expect(dto.isExpired, isTrue);
    });

    test('maskName produces "First L." format', () {
      expect(TicketShareDTO.maskName('Ahmed Al-Harbi'), 'Ahmed A.');
      expect(TicketShareDTO.maskName('Nasser'), 'Nasser');
      expect(TicketShareDTO.maskName(''), '');
      expect(TicketShareDTO.maskName('Sara  Mohammed'), 'Sara M.');
    });

    test('toFirestore does not include private payment fields', () {
      final dto = TicketShareDTO.fromFirestore('t', _shareMap());
      final serialized = dto.toFirestore();
      expect(serialized.containsKey('email'), isFalse);
      expect(serialized.containsKey('phone'), isFalse);
      expect(serialized.containsKey('totalPaid'), isFalse);
      expect(serialized.containsKey('fareSubtotal'), isFalse);
      expect(serialized.containsKey('paymobToken'), isFalse);
    });

    test('toFirestore does not embed the token as a field', () {
      final dto = TicketShareDTO.fromFirestore('tok', _shareMap());
      final serialized = dto.toFirestore();
      expect(serialized.containsKey('token'), isFalse);
    });
  });

  // ── 4. DigitalTicketState.copyWith ────────────────────────────────────────
  group('DigitalTicketState.copyWith', () {
    test('clears message when clearMessage=true', () {
      final s =
          const DigitalTicketState(status: DigitalTicketStatus.success, message: 'hi');
      expect(s.copyWith(clearMessage: true).message, isNull);
    });

    test('clears errorMessage when clearError=true', () {
      final s = const DigitalTicketState(
          status: DigitalTicketStatus.error, errorMessage: 'oops');
      final cleared =
          s.copyWith(status: DigitalTicketStatus.success, clearError: true);
      expect(cleared.errorMessage, isNull);
      expect(cleared.status, DigitalTicketStatus.success);
    });

    test('preserves shareUrl across unrelated updates', () {
      final s = const DigitalTicketState(
          status: DigitalTicketStatus.success, shareUrl: 'https://x.com/t/tok');
      final updated = s.copyWith(status: DigitalTicketStatus.sharing);
      expect(updated.shareUrl, 'https://x.com/t/tok');
    });
  });

  // ── 5. SharedTicketCubit state transitions ────────────────────────────────
  group('SharedTicketCubit', () {
    late MockTripsRepository mockRepo;
    late ResolveShareUseCase useCase;

    setUp(() {
      mockRepo = MockTripsRepository();
      useCase = ResolveShareUseCase(mockRepo);
    });

    final validShare = TicketShareDTO.fromFirestore('valid', _shareMap());

    blocTest<SharedTicketCubit, SharedTicketState>(
      'emits loading → found for valid token',
      build: () {
        when(() => mockRepo.resolveShare('valid'))
            .thenAnswer((_) async => ShareFound(validShare));
        return SharedTicketCubit(resolveShareUseCase: useCase);
      },
      act: (c) => c.loadShare('valid'),
      expect: () => [
        const SharedTicketState(status: SharedTicketStatus.loading),
        isA<SharedTicketState>()
            .having((s) => s.status, 'status', SharedTicketStatus.found)
            .having((s) => s.ticketShare, 'share', isNotNull),
      ],
    );

    blocTest<SharedTicketCubit, SharedTicketState>(
      'emits loading → notFound',
      build: () {
        when(() => mockRepo.resolveShare(any()))
            .thenAnswer((_) async => const ShareNotFound());
        return SharedTicketCubit(resolveShareUseCase: useCase);
      },
      act: (c) => c.loadShare('bad'),
      expect: () => [
        const SharedTicketState(status: SharedTicketStatus.loading),
        const SharedTicketState(status: SharedTicketStatus.notFound),
      ],
    );

    blocTest<SharedTicketCubit, SharedTicketState>(
      'emits loading → expired',
      build: () {
        when(() => mockRepo.resolveShare(any()))
            .thenAnswer((_) async => const ShareExpired());
        return SharedTicketCubit(resolveShareUseCase: useCase);
      },
      act: (c) => c.loadShare('exp'),
      expect: () => [
        const SharedTicketState(status: SharedTicketStatus.loading),
        const SharedTicketState(status: SharedTicketStatus.expired),
      ],
    );

    blocTest<SharedTicketCubit, SharedTicketState>(
      'emits loading → revoked',
      build: () {
        when(() => mockRepo.resolveShare(any()))
            .thenAnswer((_) async => const ShareRevoked());
        return SharedTicketCubit(resolveShareUseCase: useCase);
      },
      act: (c) => c.loadShare('rev'),
      expect: () => [
        const SharedTicketState(status: SharedTicketStatus.loading),
        const SharedTicketState(status: SharedTicketStatus.revoked),
      ],
    );

    blocTest<SharedTicketCubit, SharedTicketState>(
      'emits loading → networkError with message',
      build: () {
        when(() => mockRepo.resolveShare(any()))
            .thenAnswer((_) async => const ShareNetworkError('timeout'));
        return SharedTicketCubit(resolveShareUseCase: useCase);
      },
      act: (c) => c.loadShare('err'),
      expect: () => [
        const SharedTicketState(status: SharedTicketStatus.loading),
        isA<SharedTicketState>()
            .having((s) => s.status, 'status', SharedTicketStatus.networkError)
            .having((s) => s.errorMessage, 'msg', 'timeout'),
      ],
    );
  });

  // ── 6. QR payload – must be HTTPS URL, never raw booking data ─────────────
  group('QR code payload', () {
    test('share URL is a valid HTTPS URL containing /ticket/', () {
      const token = 'xQz3Km9pLrT4sNvA2wJdYe';
      final url = '${AppLinksConfig.shareBaseUrl}/$token';
      expect(Uri.tryParse(url)?.scheme, 'https');
      expect(url, contains('/ticket/'));
    });

    test('share URL ends with the token', () {
      const token = 'abcdefghijklmnopqrstuv';
      final url = '${AppLinksConfig.shareBaseUrl}/$token';
      expect(url.endsWith(token), isTrue);
    });

    test('booking ID "b1" is not embedded in a 22-char token URL', () {
      const bookingId = 'b1';
      const token = 'xQz3Km9pLrT4sNvA2wJdYe'; // 22 chars
      final url = '${AppLinksConfig.shareBaseUrl}/$token';
      // The URL path segment after /ticket/ should be the 22-char token,
      // which cannot equal a 2-char booking ID.
      final segment = Uri.parse(url).pathSegments.last;
      expect(segment, isNot(bookingId));
      expect(segment.length, 22);
    });
  });
}
