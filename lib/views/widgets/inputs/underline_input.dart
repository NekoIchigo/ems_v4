import 'package:ems_v4/global/constants.dart';
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
      style: const TextStyle(color: darkGray, fontSize: 15),
      decoration: InputDecoration(
        focusedBorder:
            const UnderlineInputBorder(borderSide: BorderSide(color: darkGray)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: darkGray),
        ),
        labelText: widget.label,
        labelStyle: const TextStyle(color: darkGray),
        suffixIcon: !widget.isPassword
            ? Icon(widget.icon, color: darkGray)
            : InkWell(
                onTap: _togglePasswordView,
                child: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: darkGray,
                ),
              ),
        floatingLabelStyle:
            const TextStyle(color: darkGray, letterSpacing: 1.3, fontSize: 14),
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
