import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/pages/authen/reset_password_page.dart';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/utils/config.dart';
import 'dart:async'; // Import this for the Timer class



class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  VerifyEmailPageState createState() => VerifyEmailPageState();
}

class VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _codeControllers =
    List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isButtonEnabled = true;
  String _buttonText = "Verify";
  Timer? _timer;
  int _remainingSeconds = 60;

  Future<void> verify() async {
    if (!_isButtonEnabled) return;
    String code = _codeControllers.map((c) => c.text).join();

    // Ensure the code is a 4-digit number
    if (code.length != 4 || !code.split('').every((digit) => digit.contains(RegExp(r'[0-9]')))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter 4 digits (0-9)"),
        ),
      );
      return;
    }

    _startTimer(); 

    var response = await http.post(
      Uri.parse('${Config.apiUrl}/api/users/validate-token'),
      body: {'token': code},
    );

    // Parse the response body to a variable
    String responseBody = response.body;

    // Check the response body content to determine the outcome
    if (response.statusCode == 200 && responseBody.toString().contains("Token validated")) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage(token: code)));
    } else if (responseBody.contains("Token expired")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Token expired or invalid."),
        ),
      );
    } else {
      // Handle any other unexpected responses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unexpect token result"),
        ),
      );
    }
  }

  void _startTimer() {
    _remainingSeconds = 60; // Reset the timer to 60 seconds
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _buttonText = "Send code again in $_remainingSeconds s";
          _isButtonEnabled = false;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _buttonText = "Verify";
          _isButtonEnabled = true;
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
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
                  onTap: _isButtonEnabled ? verify : null,
                  buttonText: _buttonText,
                  isFilled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
