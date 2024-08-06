import 'package:flutter/material.dart';
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
  final GlobalKey<FormFieldState>? fieldKey;
  final bool readOnly; // New parameter

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
    this.readOnly = false, // Default to false
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late bool _obscureText;
  String? _errorText;
  bool _userHasInteracted = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    widget.controller.addListener(_validate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validate);
    super.dispose();
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _validate() {
    final text = widget.controller.text;

    final currentError = widget.validator?.call(text);
    if (currentError != _errorText) {
      setState(() {
        _errorText = currentError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              key: widget.fieldKey,
              controller: widget.controller,
              obscureText: _obscureText,
              textInputAction: widget.textInputAction,
              readOnly: widget.readOnly, // Apply readOnly property
              decoration: InputDecoration(
                prefixIcon: widget.prefixIcon,
                hintText: widget.hintText,
                hintStyle: CustomTextStyles.hintTextField,
                labelText: _errorText ?? widget.labelText,
                labelStyle: _errorText != null
                    ? CustomTextStyles.labelTextErrorField
                    : CustomTextStyles.labelTextField,
                errorText: null,
                errorStyle: const TextStyle(
                  color: Colors.transparent,
                  fontSize: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color:
                        widget.readOnly ? Colors.grey.shade900 : Colors.white,
                    width: widget.readOnly ? 2.0 : 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey.shade900,
                    width: 2.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2.0,
                  ),
                ),
              ),
              validator: (text) => _errorText,
              onChanged: (text) {
                if (!_userHasInteracted) {
                  setState(() {
                    _userHasInteracted = true;
                  });
                }
                widget.onChanged?.call(text);
              },
            ),
            if (widget.showRevealButton && !widget.readOnly)
              Positioned(
                right: 5,
                child: IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: _toggleObscureText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
