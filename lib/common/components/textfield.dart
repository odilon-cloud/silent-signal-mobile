// import 'package:flutter/material.dart';

// class InputTextField extends StatelessWidget {
//   final controller;
//   final String hintText;
//   final String? labelText;  // Add labelText parameter
//   final bool obscureText;
//   final int? maxLines;

//   const InputTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.labelText,  // Make it optional
//     required this.obscureText,
//     this.maxLines = 1,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (labelText != null) ...[
//             Text(
//               labelText!,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),  // Space between label and field
//           ],
//           TextField(
//             controller: controller,
//             obscureText: obscureText,
//             maxLines: maxLines,
//             decoration: InputDecoration(
//               enabledBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.white),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey.shade400),
//               ),
//               fillColor: Colors.grey.shade200,
//               filled: true,
//               hintText: hintText,
//               hintStyle: TextStyle(color: Colors.grey[500])
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final String? labelText;
  final bool obscureText;
  final int? maxLines;

  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    required this.obscureText,
    this.maxLines = 1,
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
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: controller,
            obscureText: obscureText,
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
              // Add these for smaller height on single-line inputs
              contentPadding: maxLines == 1 
                ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              isDense: maxLines == 1 ? true : false,
            ),
          ),
        ],
      ),
    );
  }
}