import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

class NoServerConnectPage extends StatelessWidget {
  const NoServerConnectPage({super.key});

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
                  const Stack(
                    children: [
                      Icon(
                        Icons.storage,
                        size: 112,
                        color: Colors.blue,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.error,
                          size: 24,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Text(
                    AppLocalizations.of(context)!.noServerConnect,
                    style: CustomTextStyles.labelTextField,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.noServerConnect1,
                    style: CustomTextStyles.labelTextField,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    AppLocalizations.of(context)!.noServerConnect2,
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
