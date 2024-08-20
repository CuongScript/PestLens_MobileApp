import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/pages/authen/reset_password_page.dart';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/preferences/user_preferences.dart';
import 'dart:convert';



class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  VerifyEmailPageState createState() => VerifyEmailPageState();
}

class VerifyEmailPageState extends State<VerifyEmailPage> {
  // final List<TextEditingController> _codeControllers =
  //     List.generate(4, (_) => TextEditingController());
  // final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  // void verify() {
  //   String code = _codeControllers.map((controller) => controller.text).join();
  //   int codeInt;
  //   try {
  //     codeInt = int.parse(code);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(AppLocalizations.of(context)!
  //             .invalidForgetPasswordVerificationCode),
  //       ),
  //     );
  //     return;
  //   }

  //   // Replace the following line with  verification logic
  //   if (codeInt == 1234) {
  //     // Example check, replace with actual verification logic

  //     Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => ResetPasswordPage()));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(AppLocalizations.of(context)!
  //             .invalidForgetPasswordVerificationCode),
  //       ),
  //     );
  //   }
  final List<TextEditingController> _codeControllers =
    List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());


  Future<void> verify() async {
    String code = _codeControllers.map((c) => c.text).join();

    // Ensure the code is a 4-digit number
    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid 1"),
        ),
      );
      return;
    }

    // Fetch user credentials from preferences
    final user = await UserPreferences.getUser();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not authen 1"),
        ),
      );
      return;
    }

    var response = await http.post(
      Uri.parse('${Config.apiUrl}/api/users/validate-token'),
      headers: {
        'Authorization': '${user.tokenType} ${user.accessToken}',
      },
      body: {'token': code},
    );

    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidForgetPasswordVerificationCode),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const MyBackButton(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.checkEmail,
                  style: CustomTextStyles.appName,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.textVerifyEmail,
                  style: CustomTextStyles.forgotPass,
                ),
              ),
              const SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        focusNode: _focusNodes[index],
                        controller: _codeControllers[index],
                        maxLength: 1,
                        decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.black, // Default border color
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors
                                    .white, // Color for the enabled border
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors
                                    .black, // Color for the focused border
                                width:
                                    2.0, // Optional: Adjust the width of the focused border
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Colors.red, // Color for the error border
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        autofocus: index == 0,
                        style: CustomTextStyles.emailVerifyText,
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 33),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: MySubmitButton(
                  onTap: verify,
                  buttonText: AppLocalizations.of(context)!.verify,
                  isFilled: true,
                ),
              ),
              const SizedBox(height: 20),
              if (true) // TODO: add logic here
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Send code again in 60s")],
                )
              else
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Send code again",
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
