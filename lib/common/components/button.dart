// import 'package:flutter/material.dart';

// class SampleButton extends StatelessWidget {
//   final Function()? onTap;
//   final String buttonText;  // Added parameter for button text

//   const SampleButton({
//     super.key, 
//     required this.onTap,
//     required this.buttonText,  // Make it required
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//         margin: const EdgeInsets.symmetric(horizontal: 25),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             buttonText,  
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class SampleButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Color? buttonColor;
  final double? width;
  final double? height;

  const SampleButton({
    super.key, 
    required this.onTap,
    required this.buttonText,
    this.buttonColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic padding based on height
    double verticalPadding = height != null ? height! * 0.2 : 15.0; // 20% of height or default 15
    double horizontalPadding = height != null ? height! * 0.3 : 25.0; // 30% of height or default 25

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: height != null ? height! * 0.4 : 16, // Dynamic font size
            ),
          ),
        ),
      ),
    );
  }
}