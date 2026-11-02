import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
      label: 'Digital Boarding Pass QR Code for booking $bookingRef',
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E5EA), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrData.isNotEmpty ? qrData : 'RIDEWAY|INVALID',
                version: QrVersions.auto,
                size: 170,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
                embeddedImage: null,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
              ),
              const SizedBox(height: 10),
              Text(
                bookingRef,
                style: const TextStyle(
                  fontSize: 13,
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
