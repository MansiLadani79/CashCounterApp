import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/color/colors.dart';

class CommonTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final bool showSuffixIcon;
  final bool readOnly;
  final bool disableSelection;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool isUpperCase;
  final int? maxLength;

  const CommonTextFieldWidget({
    this.isUpperCase = false,
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.showSuffixIcon = false,
    this.readOnly = false,
    this.disableSelection = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  }) : super(key: key);

  @override
  _CommonTextFieldWidgetState createState() => _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    // Enforce max length directly on the controller text
    if (widget.maxLength != null) {
      widget.controller.text = widget.controller.text.substring(
        0,
        widget.controller.text.length > widget.maxLength!
            ? widget.maxLength!
            : widget.controller.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: AbsorbPointer(
        absorbing: widget.disableSelection,
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          showCursor: !widget.disableSelection,
          style: const TextStyle(fontSize: 16),
          textCapitalization: widget.isUpperCase
              ? TextCapitalization.characters
              : TextCapitalization.sentences,
          inputFormatters: [
            if (widget.maxLength != null)
              LengthLimitingTextInputFormatter(widget.maxLength),
          ],
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(color: textColor),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(widget.icon, color: textColor),
            suffixIcon: widget.showSuffixIcon && !widget.disableSelection
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            counterText: "", // Remove counter below text field
          ),
        ),
      ),
    );
  }
}
