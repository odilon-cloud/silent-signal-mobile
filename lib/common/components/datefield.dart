import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class DateInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final String hintText;

//   const DateInputField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//   });

//   @override
//   State<DateInputField> createState() => _DateInputFieldState();
// }

// class _DateInputFieldState extends State<DateInputField> {
//   Future<void> _selectDate() async {
//   try {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2030),  // Extended the last date to 2030 instead of 2025
//     );

//     if (picked != null) {
//       setState(() {
//         widget.controller.text = DateFormat('dd/MM/yyyy').format(picked);
//       });
//     }
//   } catch (e) {
//     print('Error showing date picker: $e');
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25.0),
//       child: TextField(
//         controller: widget.controller,
//         readOnly: true,
//         onTap: () {
//           print('TextField tapped'); // Debug print
//           _selectDate();
//         },
//         decoration: InputDecoration(
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey.shade400),
//           ),
//           fillColor: Colors.grey.shade200,
//           filled: true,
//           hintText: widget.hintText,
//           hintStyle: TextStyle(color: Colors.grey[500]),
//           suffixIcon: IconButton(
//             onPressed: () {
//               print('Icon button pressed'); // Debug print
//               _selectDate();
//             },
//             icon: const Icon(Icons.calendar_today),
//           ),
//         ),
//       ),
//     );
//   }
// }

class DateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;  // Add labelText parameter

  const DateInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,  // Make it optional
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
   Future<void> _selectDate() async {
  try {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),  
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  } catch (e) {
    print('Error showing date picker: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null) ...[
            Text(
              widget.labelText!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),  // Space between label and field
          ],
          TextField(
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
              suffixIcon: IconButton(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_today),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
