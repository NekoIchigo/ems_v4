import 'package:flutter/material.dart';

class UnderlineInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData icon;
  final TextEditingController textController;
  const UnderlineInput({
    super.key,
    required this.label,
    required this.isPassword,
    required this.icon,
    required this.textController,
  });

  @override
  State<UnderlineInput> createState() => _UnderlineInputState();
}

class _UnderlineInputState extends State<UnderlineInput> {
  bool _isObscure = true;

  _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? _isObscure : false,
      controller: widget.textController,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.white),
        suffixIcon: !widget.isPassword
            ? Icon(widget.icon, color: Colors.white)
            : InkWell(
                onTap: _togglePasswordView,
                child: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              ),
        floatingLabelStyle: const TextStyle(
            color: Colors.white, letterSpacing: 1.3, fontSize: 14),
      ),
      validator: (String? value) {
        if (value == null || value == '') {
          return '';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.disabled,
    );
  }
}
