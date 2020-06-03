import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Fields {
  static Widget customTextField(
      {@required FormFieldValidator<String> validator,
      @required TextEditingController controller,
      @required TextInputType textInputType,
      List<TextInputFormatter> textFieldInputFormatters,
      int maxLines,
      int minLines}) {
    return TextFormField(
      minLines: minLines != null && minLines > 1 ? minLines : 1,
      maxLines: maxLines == null
          ? null
          : maxLines, //maxLines as null makes it a auto expanding field
      controller: controller,
      inputFormatters: textFieldInputFormatters,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 1, color: Colors.grey[50])),
          fillColor: Colors.grey[100],
          filled: true),
    );
  }
}
