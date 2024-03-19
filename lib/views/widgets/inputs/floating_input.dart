import 'package:ems_v4/global/constants.dart';
import 'package:flutter/material.dart';

class FloatingInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData icon;
  final TextEditingController textController;
  final String? errorText;
  final double? borderRadius;
  final Color? iconColor;
  final Function(String) onChanged;
  final Function()? onIconPressed;
  final Function(String?) validator;

  const FloatingInput({
    super.key,
    required this.label,
    required this.isPassword,
    required this.textController,
    required this.icon,
    this.errorText,
    required this.onChanged,
    this.borderRadius,
    this.iconColor,
    this.onIconPressed,
    required this.validator,
  });

  @override
  State<FloatingInput> createState() => _FloatingInputState();
}

class _FloatingInputState extends State<FloatingInput> {
  bool _isObscure = true;

  _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        // boxShadow: const [
        //   BoxShadow(
        //     color: lightGray,
        //     blurRadius: 3,
        //     offset: Offset(0, 2), // Shadow position
        //   ),
        // ],
      ),
      child: TextFormField(
        obscureText: widget.isPassword ? _isObscure : false,
        controller: widget.textController,
        style: const TextStyle(color: gray, fontSize: 15),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          error: hasError(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: lightGray),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 5),
          ),
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryBlue),
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 5)),
          labelText: widget.label,
          labelStyle: const TextStyle(color: gray),
          suffixIcon: !widget.isPassword
              ? InkWell(
                  onTap: widget.onIconPressed,
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor ?? gray,
                  ))
              : InkWell(
                  onTap: _togglePasswordView,
                  child: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: widget.iconColor ?? gray,
                  ),
                ),
          floatingLabelStyle:
              MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : Colors.black;
            return TextStyle(color: color, letterSpacing: 1.3, fontSize: 14);
          }),
        ),
        validator: (String? value) {
          return widget.validator(value);
        },
        autovalidateMode: AutovalidateMode.disabled,
      ),
    );
  }

  Widget? hasError() {
    if (widget.errorText != null && widget.errorText != '') {
      return Container(
        color: Colors.transparent,
        child: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: colorError,
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              widget.errorText!,
              style: const TextStyle(color: colorError, fontSize: 12),
            )
          ],
        ),
      );
    }

    return null;
  }
}
