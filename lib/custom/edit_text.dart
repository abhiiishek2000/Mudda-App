import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditText extends StatefulWidget {
  String hint;
  TextInputType keyboradType;
  bool isObscureText;
  final bool isPassword, readOnly;
  String? Function(String)? validator;

  TextEditingController? controller;

  int maxLine;

  EditText(
      {Key? key,
      this.hint = "",
      this.keyboradType = TextInputType.text,
      this.controller,
      this.maxLine = 1,
      this.readOnly = false,
      this.isObscureText = false,
      this.isPassword = false,
      this.validator})
      : super(key: key);

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLine,
      readOnly: widget.readOnly,
      controller: widget.controller,
      obscureText: widget.isObscureText,
      keyboardType: widget.keyboradType,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0)
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
          filled: true,
          helperText: widget.isPassword
              ? "At least 8 characters with Uppercase, Lowercase and Special characters."
              : null,
          helperStyle:
              const TextStyle(fontWeight: FontWeight.w100, fontSize: 8),
          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.bodyText1,
         ),
      validator: (value) {
        return widget.validator!(value!);
      },
    );
  }
}
