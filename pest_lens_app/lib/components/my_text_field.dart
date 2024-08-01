import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
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
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey.shade900,
                    width: 2.0,
                  ), // Remove the border
                ),
              ),
            ),
            if (widget.showRevealButton)
              Positioned(
                right: 5,
                child: IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ), // Icon for the reveal button
                  onPressed: _toggleObscureText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
