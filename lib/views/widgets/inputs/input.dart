import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController textController;
  final int? max;
  const Input({
    super.key,
    required this.label,
    required this.isPassword,
    required this.textController,
    this.max,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _isObscure = true;

  _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        TextFormField(
          obscureText: widget.isPassword ? _isObscure : false,
          controller: widget.textController,
          style: const TextStyle(color: gray, fontSize: 14),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelStyle: const TextStyle(color: gray),
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: gray,
                    ),
                  )
                : const SizedBox(
                    width: 1,
                    height: 1,
                  ),
          ),
          validator: (String? value) {
            if (value == null || value == '') {
              return '';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.disabled,
        ),
      ],
    );
  }
}
