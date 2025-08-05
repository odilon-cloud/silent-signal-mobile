import 'package:flutter/material.dart';

class SampleButton extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Color? buttonColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final String? loadingText;

  const SampleButton({
    super.key, 
    required this.onTap,
    required this.buttonText,
    this.buttonColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic padding based on height
    double verticalPadding = height != null ? height! * 0.2 : 15.0; // 20% of height or default 15
    double horizontalPadding = height != null ? height! * 0.3 : 25.0; // 30% of height or default 25

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : (buttonColor ?? Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: height != null ? height! * 0.5 : 20,
                      height: height != null ? height! * 0.5 : 20,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: height != null ? height! * 0.2 : 8),
                    Text(
                      loadingText ?? 'Loading...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: height != null ? height! * 0.4 : 16,
                      ),
                    ),
                  ],
                )
              : Text(
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