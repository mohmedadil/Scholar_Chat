import 'package:flutter/material.dart';

class Custom_FormField extends StatelessWidget {
  String? hint;
  bool? obsecure ;
  Function(String data)? onchanged;
  Custom_FormField({required this.onchanged, required this.hint,this.obsecure=false});
  @override
  Widget build(Object context) {
    return TextFormField(obscureText:obsecure! ,
      validator: (value) {
        if (value!.isEmpty) {
          return 'this field is requird';
        }
      },
      onChanged: onchanged!,
      decoration: InputDecoration(
        hintText: hint!,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
