// import 'package:flutter/material.dart';
// import 'package:pest_lens_app/assets/colors.dart';
// import 'package:pest_lens_app/components/my_back_button.dart';
// import 'package:pest_lens_app/components/my_text_form_field.dart';
// import 'package:pest_lens_app/components/my_text_style.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:pest_lens_app/components/my_submit_button.dart';
// import 'package:pest_lens_app/utils/textfield_validator.dart';

// class ResetPasswordPage extends StatelessWidget {
//   final String token;
//   ResetPasswordPage({super.key, required this.token});
//   final _formKey = GlobalKey<FormState>();
//   final passwordController = TextEditingController();
//   final rePasswordController = TextEditingController();
//   // final passwordFieldKey = GlobalKey<FormFieldState>();
//   // final rePasswordFieldKey = GlobalKey<FormFieldState>();

//   // void resetPass() {}

//   // void _validateField(GlobalKey<FormFieldState> key) {
//   //   final field = key.currentState;
//   //   field?.validate();
//   // }
//   Future<void> resetPass(BuildContext context) async {
//     if (_formKey.currentState!.validate()) {
//       var response = await http.post(
//         Uri.parse('${Config.apiUrl}/api/users/change-password'),
//         body: {
//           'token': token, // Use the passed token here
//           'password': passwordController.text,
//         }
//       );

//       // Handle the response
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: primaryBackgroundColor,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: IconButton(
//             icon: const MyBackButton(),
//             onPressed: () {
//               Navigator.of(context).popUntil((route) => route.isFirst);
//             },
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 64,
//                 ),
//                 Text(
//                   AppLocalizations.of(context)!.resetPass,
//                   style: CustomTextStyles.appName,
//                 ),
//                 const SizedBox(
//                   height: 9,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 50.0),
//                   child: Text(
//                     AppLocalizations.of(context)!.textResetPass,
//                     style: CustomTextStyles.forgotPass,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 49,
//                 ),
//                 MyTextFormField(
//                   fieldKey: passwordFieldKey,
//                   controller: passwordController,
//                   obscureText: true,
//                   prefixIcon:
//                       const Icon(Icons.lock_outline, color: Colors.black),
//                   hintText: AppLocalizations.of(context)!.logInPass,
//                   showRevealButton: true,
//                   textInputAction: TextInputAction.next,
//                   labelText: AppLocalizations.of(context)!.logInPass,
//                   validator: (value) =>
//                       TextfieldValidator.validatePassword(value, context),
//                   onChanged: (value) {
//                     _validateField(passwordFieldKey);
//                   },
//                 ),
//                 const SizedBox(height: 28),
//                 MyTextFormField(
//                   fieldKey: rePasswordFieldKey,
//                   controller: rePasswordController,
//                   obscureText: true,
//                   prefixIcon:
//                       const Icon(Icons.lock_outline, color: Colors.black),
//                   hintText: AppLocalizations.of(context)!.reEnterPass,
//                   showRevealButton: true,
//                   textInputAction: TextInputAction.done,
//                   labelText: AppLocalizations.of(context)!.reEnterPass,
//                   validator: (value) => TextfieldValidator.validateRePassword(
//                       value, passwordController.text, context),
//                   onChanged: (value) {
//                     _validateField(rePasswordFieldKey);
//                   },
//                 ),
//                 const SizedBox(
//                   height: 33,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 45,
//                   ),
//                   child: MySubmitButton(
//                     onTap: () {
//                       resetPass;
//                       Navigator.of(context).popUntil((route) => route.isFirst);
//                     },
//                     buttonText: AppLocalizations.of(context)!.sendCode,
//                     isFilled: true,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/utils/textfield_validator.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;
  ResetPasswordPage({super.key, required this.token});
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  Future<void> resetPass(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse('${Config.apiUrl}/api/users/change-password'),
        body: {
          'token': token,
          'password': passwordController.text,
        }
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset successfully!"))
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to reset password: ${response.body}"))
        );
      }
    }
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
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 64),
                Text(
                  AppLocalizations.of(context)!.resetPass,
                  style: CustomTextStyles.appName,
                ),
                const SizedBox(height: 9),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    AppLocalizations.of(context)!.textResetPass,
                    style: CustomTextStyles.forgotPass,
                  ),
                ),
                const SizedBox(height: 49),
                MyTextFormField(
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                  hintText: AppLocalizations.of(context)!.logInPass,
                  showRevealButton: true,
                  textInputAction: TextInputAction.next,
                  labelText: AppLocalizations.of(context)!.logInPass,
                  validator: (value) => TextfieldValidator.validatePassword(value, context),
                ),
                const SizedBox(height: 28),
                MyTextFormField(
                  controller: rePasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                  hintText: AppLocalizations.of(context)!.reEnterPass,
                  showRevealButton: true,
                  textInputAction: TextInputAction.done,
                  labelText: AppLocalizations.of(context)!.reEnterPass,
                  validator: (value) => TextfieldValidator.validateRePassword(value, passwordController.text, context),
                ),
                const SizedBox(height: 33),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: MySubmitButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        resetPass(context);
                      }
                    },
                    buttonText: AppLocalizations.of(context)!.sendCode,
                    isFilled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
