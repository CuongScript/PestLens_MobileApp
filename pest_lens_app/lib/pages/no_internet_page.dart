import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 253),
                  const Icon(
                    Icons.wifi_off,
                    size: 112,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    AppLocalizations.of(context)!.noIntConnect,
                    style: CustomTextStyles.labelTextField,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.noIntConnect1,
                    style: CustomTextStyles.labelTextField,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
