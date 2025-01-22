// import 'package:flutter/material.dart';

// class InputTextField extends StatelessWidget {
//   final controller;
//   //final String labelText;
//   final String hintText;
//   final bool obscureText;

//   const InputTextField({
//     super.key,
//     //required this.labelText,
//     required this.controller,
//     required this.hintText,
//     required this.obscureText,
    
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//  //           labelText: labelText,
//             enabledBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//             fillColor: Colors.grey.shade200,
//             filled: true,
//             hintText: hintText,
//             hintStyle: TextStyle(color: Colors.grey[500])),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final int? maxLines; // Add this parameter for text area support

  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.maxLines = 1, // Default to 1 line for normal text input
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines, // Use the maxLines parameter
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
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}