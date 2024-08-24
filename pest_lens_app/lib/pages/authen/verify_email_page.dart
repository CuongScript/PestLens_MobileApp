import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/pages/authen/reset_password_page.dart';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/utils/config.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  // final Future<void> Function(BuildContext) resendCodeFunction;
  const VerifyEmailPage({super.key, required this.email});

  @override
  VerifyEmailPageState createState() => VerifyEmailPageState();
}

class VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _codeControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResendCode = false;

  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the countdown as soon as the page is loaded
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    setState(() {
      _remainingSeconds = 60;
      _canResendCode = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResendCode = true; // Allow resend after countdown
        });
      }
    });
  }

  Future<void> verify() async {
    String code = _codeControllers.map((c) => c.text).join();

    if (code.length != 4 ||
        !code.split('').every((digit) => digit.contains(RegExp(r'[0-9]')))) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.enter4Digit)));
      return;
    }

    var response = await http.post(
        Uri.parse('${Config.apiUrl}/api/users/validate-token'),
        body: {'token': code});

    if (response.statusCode == 200 &&
        response.body.contains("Token validated")) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPasswordPage(token: code)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.tokenExpire)));
    }
  }

  Future<void> sendResetPasswordRequest(BuildContext context) async {
    final response = await http.post(
        Uri.parse('${Config.apiUrl}/api/users/reset-password'),
        body: {'email': widget.email});
    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.errorForgotPassword)));
    }
  }

  void resendCode() async {
    if (_canResendCode) {
      _canResendCode = false;
      await sendResetPasswordRequest(context);
      _startTimer();
    }
  }

  @override
  void dispose() {
    _codeControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
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
              Text(AppLocalizations.of(context)!.checkEmail,
                  style: CustomTextStyles.appName),
              const SizedBox(height: 12),
              Text(AppLocalizations.of(context)!.textVerifyEmail,
                  style: CustomTextStyles.forgotPass),
              const SizedBox(height: 27),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      4, (index) => buildCodeInput(context, index))),
              const SizedBox(height: 33),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: MySubmitButton(
                    onTap: verify,
                    buttonText: AppLocalizations.of(context)!.verify,
                    isFilled: true),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _canResendCode
                      ? TextButton(
                          onPressed: resendCode,
                          child: Text(
                              AppLocalizations.of(context)!.clickResendCode))
                      : Text(
                          "${AppLocalizations.of(context)!.sendCodeAgain} $_remainingSeconds s")),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCodeInput(BuildContext context, int index) {
    return SizedBox(
      width: 50,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 4))
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
                  borderSide: BorderSide(color: Colors.black)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.black, width: 2.0)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.red)),
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
  }
}
