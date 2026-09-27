import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ButtonChangingLanguage extends StatelessWidget {
  const ButtonChangingLanguage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        context.locale.languageCode == 'ar'
            ? Icons.language
            : Icons.translate,
      ),
      onPressed: () {
        final newLocale = context.locale.languageCode == 'ar'
            ? const Locale('en')
            : const Locale('ar');
        context.setLocale(newLocale);
      },
    );
  }
}
