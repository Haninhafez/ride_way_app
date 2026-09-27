import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';

/// A row of 6 OTP digit input boxes.
///
/// CRITICAL: Always rendered in LTR digit order regardless of device locale,
/// achieved by wrapping in [Directionality(textDirection: TextDirection.ltr)].
///
/// Auto-advances focus to the next box on digit entry and moves backward
/// on backspace when the current box is empty.
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({
    super.key,
    required this.onCompleted,
    this.length = 6,
  });

  final void Function(String code) onCompleted;
  final int length;

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        final code = _controllers.map((c) => c.text).join();
        if (code.length == widget.length) {
          widget.onCompleted(code);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL: OTP boxes must always be in LTR digit order
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.length, (i) {
          return _OtpBox(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            onChanged: (val) => _onChanged(val, i),
            onBackspace: () {
              if (_controllers[i].text.isEmpty && i > 0) {
                _focusNodes[i - 1].requestFocus();
                _controllers[i - 1].clear();
              }
            },
          );
        }),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspace();
          }
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: kColorPrimaryAction,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: kColorFieldFill,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kColorBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: kColorPrimaryAction,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
