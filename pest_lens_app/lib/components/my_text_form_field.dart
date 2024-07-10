import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Icon? prefixIcon;
  final String? hintText;
  final bool showRevealButton;
  final TextInputAction textInputAction;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GlobalKey<FormFieldState>?
      fieldKey; // Change to GlobalKey<FormFieldState>

  const MyTextFormField({
    super.key,
    required this.controller,
    required this.obscureText,
    this.prefixIcon,
    this.hintText,
    this.showRevealButton = false,
    required this.textInputAction,
    this.labelText,
    this.validator,
    this.onChanged,
    this.fieldKey,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
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
          TextFormField(
            key: widget.fieldKey, // Use GlobalKey<FormFieldState>
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
            validator: widget.validator,
            onChanged: widget.onChanged,
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
