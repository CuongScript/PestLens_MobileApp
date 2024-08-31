import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/profile_image_picker.dart';
import 'package:pest_lens_app/provider/user_register_model_provider.dart';
import 'package:pest_lens_app/services/auth_service.dart';
import 'package:pest_lens_app/utils/textfield_validator.dart';
import 'package:pest_lens_app/components/signup_popup_dialog.dart';

class SignupProfilePage extends ConsumerStatefulWidget {
  const SignupProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends ConsumerState<SignupProfilePage> {
  final formKey = GlobalKey<FormState>();
  final firstNameFieldKey = GlobalKey<FormFieldState>();
  final lastNameFieldKey = GlobalKey<FormFieldState>();
  final phoneNumberFieldKey = GlobalKey<FormFieldState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final AuthService _authService = AuthService();
  File? _profileImage;

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

  void _handleImagePicked(File image) {
    setState(() {
      _profileImage = image;
    });
  }

  Future<void> signUserUp() async {
    if (formKey.currentState?.validate() ?? false) {
      final userModel = ref.read(userRegisterModelProvider);
      final userData = userModel
          .copyWith(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneNumberController.text,
          )
          .toJson();

      final result = await _authService.signUserUp(userData, _profileImage);

      if (mounted) {
        if (result['success']) {
          showSignupPopup(context, true, message: result['message']);
          ref.read(userRegisterModelProvider.notifier).reset();
        } else {
          if (result['imageUploadFailed'] == true) {
            showImageUploadWarning(
              context,
              () {
                showSignupPopup(context, true,
                    message:
                        'Signup successful, but profile image upload failed.');
              },
            );
          } else {
            showSignupPopup(context, false, message: result['message']);
          }
        }
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
                const SizedBox(height: 20),
                const Text(
                  "User Profile",
                  style: CustomTextStyles.appName,
                ),
                const SizedBox(height: 28),
                ProfileImagePicker(
                  onImagePicked: _handleImagePicked,
                ),
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
