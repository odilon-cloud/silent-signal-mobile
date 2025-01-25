import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final String? labelText;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final double? verticalPadding;

  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    required this.obscureText,
    this.minLines = 1,
    this.maxLines = 1,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            Text(
              labelText!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: controller,
            obscureText: obscureText,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: verticalPadding ?? (maxLines == 1 ? 10 : 16),
              ),
              isDense: maxLines == 1 ? true : false,
            ),
          ),
        ],
      ),
    );
  }
}