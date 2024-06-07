import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

//How to call!
// MyTextField(
//   controller: usernameController,
//   obscureText: false,
//   prefixIcon: const Icon(Icons.email, color: Colors.black),
//   hintText: AppLocalizations.of(context)!.logInEmail,
//   showRevealButton: false,
//   textInputAction: TextInputAction.next, //TextInputAction.done to stop and hide keyboard
//   labelText: 'Username',
//   )


class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Icon? prefixIcon;
  final String? hintText;
  final bool showRevealButton;
  final TextInputAction textInputAction;
  final String? labelText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    this.prefixIcon,
    this.hintText,
    this.showRevealButton = false,
    required this.textInputAction,
    this.labelText,
  });

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            controller: widget.controller,
            obscureText: _obscureText,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              hintStyle: CustomTextStyles.hintTextField,
              labelText: widget.labelText,
              labelStyle: CustomTextStyles.labelTextField,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: textFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey.shade900,
                  width: 2.0,
                ),
              ),
            ),
          ),
          if (widget.showRevealButton) 
            Positioned(
              right: 5,
              child: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ), // Icon for the reveal button
                onPressed: _toggleObscureText,
              ),
            ),
        ],
      ),
    );
  }
}