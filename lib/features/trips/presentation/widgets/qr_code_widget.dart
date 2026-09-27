import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/themes/theme_data.dart';

class QRCodeWidget extends StatelessWidget {
  final String qrData;
  final String bookingRef;

  const QRCodeWidget({
    super.key,
    required this.qrData,
    required this.bookingRef,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Digital Boarding Pass QR Code for booking reference $bookingRef',
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E5EA), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // High-Contrast QR Code Visual Representation
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: CustomPaint(
                  painter: _QRPainter(),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_train,
                        size: 24,
                        color: kColorPrimaryAction,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                bookingRef,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: kColorPrimaryAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QRPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Corner Finder Patterns
    // Top-Left
    canvas.drawRect(const Rect.fromLTWH(0, 0, 36, 36), paint);
    paint.color = Colors.black;
    canvas.drawRect(const Rect.fromLTWH(6, 6, 24, 24), paint);
    paint.color = Colors.white;
    canvas.drawRect(const Rect.fromLTWH(12, 12, 12, 12), paint);

    // Top-Right
    canvas.drawRect(Rect.fromLTWH(size.width - 36, 0, 36, 36), paint);
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(size.width - 30, 6, 24, 24), paint);
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(size.width - 24, 12, 12, 12), paint);

    // Bottom-Left
    canvas.drawRect(Rect.fromLTWH(0, size.height - 36, 36, 36), paint);
    paint.color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(6, size.height - 30, 24, 24), paint);
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(12, size.height - 24, 12, 12), paint);

    // Data dots
    final double dotSize = 8;
    for (double x = 44; x < size.width - 10; x += dotSize * 1.5) {
      for (double y = 10; y < size.height - 10; y += dotSize * 1.5) {
        if ((x + y).toInt() % 3 == 0) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, y, dotSize, dotSize),
              const Radius.circular(2),
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
