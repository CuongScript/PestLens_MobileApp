import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/profile_image_picker.dart';
import 'package:pest_lens_app/provider/user_register_model_provider.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/utils/textfield_validator.dart';
import 'package:pest_lens_app/components/signup_popup_dialog.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends ConsumerState<UserProfilePage> {
  final formKey = GlobalKey<FormState>();
  final firstNameFieldKey = GlobalKey<FormFieldState>();
  final lastNameFieldKey = GlobalKey<FormFieldState>();
  final phoneNumberFieldKey = GlobalKey<FormFieldState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  void validateField(GlobalKey<FormFieldState> key) {
    final field = key.currentState;
    field?.validate();
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed.
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> signUserUp() async {
    if (formKey.currentState?.validate() ?? false) {
      // Update the provider with the latest data
      ref.read(userRegisterModelProvider.notifier).updateModel(
            ref.read(userRegisterModelProvider).copyWith(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  phoneNumber: phoneNumberController.text,
                ),
          );

      final userModel = ref.read(userRegisterModelProvider);

      // Serialize the updated user model to JSON
      final jsonData = json.encode(userModel.toJson());

      // Prepare the headers for the HTTP request
      var headers = {'Content-Type': 'application/json'};

      try {
        // Send the HTTP POST request
        final response = await http.post(
          Uri.parse('${Config.apiUrl}/signup'),
          headers: headers,
          body: jsonData,
        );

        // Ensure the widget is still mounted before showing popup
        if (!mounted) return;

        // Check the response status
        if (response.statusCode == 200) {
          ref.read(userRegisterModelProvider.notifier).reset();
          showSignupPopup(context, true);
        } else {
          showSignupPopup(context, false);
        }
      } catch (e) {
        // Ensure the widget is still mounted before showing popup
        if (!mounted) return;

        // Handle any errors that occur during the request
        showSignupPopup(context, false);
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
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 45),
                const Text(
                  "User Profile",
                  style: CustomTextStyles.appName,
                ),
                const SizedBox(height: 28),
                const ProfileImagePicker(),
                const SizedBox(height: 28),
                MyTextFormField(
                  fieldKey: firstNameFieldKey,
                  controller: firstNameController,
                  obscureText: false,
                  prefixIcon:
                      const Icon(Icons.person_outline, color: Colors.black),
                  hintText: "First Name",
                  showRevealButton: false,
                  textInputAction: TextInputAction.next,
                  labelText: "First Name",
                  validator: (value) =>
                      TextfieldValidator.validateFirstName(value, context),
                  onChanged: (value) {
                    validateField(firstNameFieldKey);
                  },
                ),
                const SizedBox(height: 28),
                MyTextFormField(
                  fieldKey: lastNameFieldKey,
                  controller: lastNameController,
                  obscureText: false,
                  prefixIcon:
                      const Icon(Icons.email_outlined, color: Colors.black),
                  hintText: "Last Name",
                  showRevealButton: false,
                  textInputAction: TextInputAction.next,
                  labelText: "Last Name",
                  validator: (value) =>
                      TextfieldValidator.validateLastName(value, context),
                  onChanged: (value) {
                    validateField(lastNameFieldKey);
                  },
                ),
                const SizedBox(height: 28),
                MyTextFormField(
                  fieldKey: phoneNumberFieldKey,
                  controller: phoneNumberController,
                  obscureText: false,
                  prefixIcon: const Icon(Icons.phone_android_outlined,
                      color: Colors.black),
                  hintText: "Phone Number",
                  showRevealButton: false,
                  textInputAction: TextInputAction.done,
                  labelText: "Phone Number",
                  validator: (value) =>
                      TextfieldValidator.validatePhoneNumber(value, context),
                  onChanged: (value) {
                    validateField(phoneNumberFieldKey);
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MySubmitButton(
                      onTap: () {
                        // Reset the user register model provider state
                        ref.read(userRegisterModelProvider.notifier).reset();

                        Navigator.pop(context);
                      },
                      buttonText: "Cancel",
                      isFilled: false,
                    ),
                    MySubmitButton(
                      onTap: signUserUp,
                      buttonText: "SignUp",
                      isFilled: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
