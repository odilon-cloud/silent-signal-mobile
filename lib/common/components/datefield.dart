// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class DateInputField extends StatefulWidget {
//   final TextEditingController controller;
//   //final String labelText;
//   final String hintText;

//   const DateInputField({
//     super.key,
//     required this.controller,
//     //required this.labelText,
//     required this.hintText,
//   });

//   @override
//   State<DateInputField> createState() => _DateInputFieldState();
// }

// class _DateInputFieldState extends State<DateInputField> {
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2025),
//     );

//     if (picked != null) {
//       setState(() {
//         widget.controller.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//       child: TextField(
//         controller: widget.controller,
//         readOnly: true,
//         onTap: _selectDate,
//         decoration: InputDecoration(
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey.shade400),
//           ),
//           fillColor: Colors.grey.shade200,
//           filled: true,
//           //labelText: widget.labelText,
//           hintText: widget.hintText,
//           hintStyle: TextStyle(color: Colors.grey[500]),
//           suffixIcon: Icon(Icons.calendar_today),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const DateInputField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        readOnly: true,
        onTap: _selectDate,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: GestureDetector(
            onTap: _selectDate, // Call the date picker when the icon is tapped
            child: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}
