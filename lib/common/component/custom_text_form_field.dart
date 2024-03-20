import 'package:flutter/material.dart';
import 'package:zodal_minzok/common/const/data.dart';

/**
 * @author zosu
 * @since 2024-03-20
 * @comment 공통 TextFormField
 **/
class CustomTextformfield extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool isObscureText;
  final bool isAutofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextformfield(
      {super.key,
      this.hintText,
      this.errorText,
      this.isObscureText = false,
      this.isAutofocus = false,
      this.onChanged});

  @override
  Widget build(BuildContext context) {

    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: isObscureText,
      autofocus: isAutofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16.0,),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
