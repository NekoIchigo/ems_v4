import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String? label;
  final bool isPassword;
  final TextEditingController textController;
  final Color? labelColor;
  final int? max;
  final String? errorText;
  final String? hintText;
  final IconData? icon;
  final bool? disabled;
  final bool? hasFocus;
  final Function(String)? onChanged;
  final Function(String?) validator;
  final Widget? prefixIcon;
  final TextInputType? textInputType;

  const Input({
    super.key,
    this.label,
    required this.isPassword,
    required this.textController,
    this.max,
    this.labelColor,
    this.errorText,
    this.icon,
    this.disabled,
    this.hasFocus,
    this.onChanged,
    this.hintText,
    required this.validator,
    this.prefixIcon,
    this.textInputType,
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
        Visibility(
          visible: widget.label != null,
          child: Text(
            widget.label ?? '',
            style: TextStyle(color: widget.labelColor ?? darkGray),
          ),
        ),
        TextFormField(
          obscureText: widget.isPassword ? _isObscure : false,
          controller: widget.textController,
          readOnly: widget.disabled ?? false,
          onChanged: widget.onChanged,
          keyboardType: widget.textInputType,
          style: const TextStyle(color: gray700, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: gray300),
            ),
            fillColor: widget.disabled ?? false
                ? gray300.withOpacity(0.5)
                : Colors.white,
            error: hasError(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: gray300)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            labelText: widget.hintText,
            labelStyle: const TextStyle(color: gray700, fontSize: 14),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: gray300,
                    ),
                  )
                : Icon(
                    widget.icon,
                    color: gray300,
                  ),
          ),
          validator: (value) {
            return widget.validator(value);
          },
          autovalidateMode: AutovalidateMode.disabled,
        ),
      ],
    );
  }

  Widget? hasError() {
    if (widget.errorText != null) {
      return Row(
        children: [
          const Icon(
            Icons.warning_rounded,
            color: colorError,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: colorError,
              fontSize: 13,
            ),
          )
        ],
      );
    }

    return null;
  }
}
