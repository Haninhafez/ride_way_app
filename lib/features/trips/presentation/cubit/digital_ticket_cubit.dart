import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/create_share_link_usecase.dart';
import '../../domain/usecases/get_digital_ticket_usecase.dart';
import '../../domain/entities/booking.dart';
import '../../../../core/config/app_links_config.dart';
import 'digital_ticket_state.dart';

class DigitalTicketCubit extends Cubit<DigitalTicketState> {
  final GetDigitalTicketUseCase getDigitalTicketUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final CreateShareLinkUseCase createShareLinkUseCase;

  ScreenshotController? screenshotController;

  DigitalTicketCubit({
    required this.getDigitalTicketUseCase,
    required this.cancelBookingUseCase,
    required this.createShareLinkUseCase,
  }) : super(const DigitalTicketState());


  Future<void> loadTicket(String bookingIdOrRef) async {
    emit(state.copyWith(status: DigitalTicketStatus.loading));
    try {
      final b = await getDigitalTicketUseCase.execute(bookingIdOrRef);
      log("Resutl form usecase : $b");
      if (b == null) {
        emit(
          state.copyWith(
            status: DigitalTicketStatus.error,
            errorMessage: 'Ticket not found.',
          ),
        );
        return;
      }

      emit(state.copyWith(status: DigitalTicketStatus.success, booking: b));

      try {
        final token = await createShareLinkUseCase.execute(b.id);
        final url = '${AppLinksConfig.shareBaseUrl}/$token';
        if (!isClosed) emit(state.copyWith(shareUrl: url));
      } catch (_) {
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: DigitalTicketStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }


  Future<void> cancelTicket() async {
    if (state.booking == null) return;
    emit(state.copyWith(status: DigitalTicketStatus.loading));
    try {
      final success = await cancelBookingUseCase.execute(state.booking!.id);
      if (success) {
        final updated = state.booking!.copyWith(
          status: BookingStatusType.cancelled,
        );
        emit(
          state.copyWith(
            status: DigitalTicketStatus.cancelled,
            booking: updated,
            message: 'ticket.cancelled_success',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DigitalTicketStatus.error,
            errorMessage: 'ticket.cancel_failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: DigitalTicketStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }


  Future<void> shareTicket() async {
    if (state.booking == null || screenshotController == null) return;
    emit(state.copyWith(status: DigitalTicketStatus.sharing));

    File? tempFile;
    try {
      final Uint8List? bytes = await screenshotController!.capture(
        pixelRatio: 3.0,
      );
      if (bytes == null) throw Exception('ticket.capture_failed');

      final tempDir = await getTemporaryDirectory();
      tempFile = File(
        '${tempDir.path}/rw_share_${state.booking!.bookingRef}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempFile.writeAsBytes(bytes);

      final token = await createShareLinkUseCase.execute(state.booking!.id);
      final shareUrl = '${AppLinksConfig.shareBaseUrl}/$token';

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFile.path, mimeType: 'image/png')],
          text: 'ticket.share_text'.replaceFirst('{url}', shareUrl),
          subject: 'RideWay – ${state.booking!.bookingRef}',
        ),
      );

      emit(
        state.copyWith(
          status: DigitalTicketStatus.shared,
          message: 'ticket.share_success',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DigitalTicketStatus.error,
          errorMessage: 'ticket.share_failed',
        ),
      );
    } finally {
      try {
        await tempFile?.delete();
      } catch (_) {}
    }
  }


  Future<void> downloadTicket() async {
    if (state.booking == null || screenshotController == null) return;
    emit(state.copyWith(status: DigitalTicketStatus.downloading));

    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          emit(
            state.copyWith(
              status: DigitalTicketStatus.error,
              errorMessage: 'ticket.download_permission_denied',
            ),
          );
          return;
        }
      }

      final Uint8List? bytes = await screenshotController!.capture(
        pixelRatio: 3.0,
      );
      if (bytes == null) throw Exception('ticket.capture_failed');

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/rw_download_${state.booking!.bookingRef}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempFile.writeAsBytes(bytes);

      await Gal.putImage(tempFile.path, album: 'RideWay');

      await tempFile.delete();

      emit(
        state.copyWith(
          status: DigitalTicketStatus.downloaded,
          message: 'ticket.download_success',
        ),
      );
    } on GalException catch (e) {
      final msg = e.type == GalExceptionType.accessDenied
          ? 'ticket.download_permission_denied'
          : 'ticket.download_failed';
      emit(
        state.copyWith(status: DigitalTicketStatus.error, errorMessage: msg),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DigitalTicketStatus.error,
          errorMessage: 'ticket.download_failed',
        ),
      );
    }
  }


  void clearMessage() {
    emit(
      state.copyWith(
        status: DigitalTicketStatus.success,
        clearMessage: true,
        clearError: true,
      ),
    );
  }
}
