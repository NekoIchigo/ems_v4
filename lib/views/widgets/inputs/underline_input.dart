import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class UnderlineInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData icon;
  final TextEditingController textController;
  final String? errorText;
  final Function(String)? onChanged;
  const UnderlineInput({
    super.key,
    required this.label,
    required this.isPassword,
    required this.icon,
    required this.textController,
    this.errorText,
    this.onChanged,
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
      style: const TextStyle(color: gray, fontSize: 15),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: lightGray)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: lightGray),
        ),
        error: hasError(),
        labelText: widget.label,
        labelStyle: const TextStyle(color: gray),
        suffixIcon: !widget.isPassword
            ? Icon(widget.icon, color: gray)
            : InkWell(
                onTap: _togglePasswordView,
                child: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: darkGray,
                ),
              ),
        floatingLabelStyle:
            const TextStyle(color: gray, letterSpacing: 1.3, fontSize: 14),
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

  Widget? hasError() {
    if (widget.errorText != null && widget.errorText != '') {
      return Row(
        children: [
          const Icon(
            Icons.warning_rounded,
            color: colorError,
            size: 18,
          ),
          const SizedBox(width: 5),
          Text(
            widget.errorText!,
            style: const TextStyle(color: colorError, fontSize: 13),
          )
        ],
      );
    }

    return null;
  }
}
