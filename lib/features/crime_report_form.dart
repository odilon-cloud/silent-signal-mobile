import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/datefield.dart';
import 'package:silentsignal/common/components/textfield.dart';

class CrimeReportForm extends StatefulWidget {
 const CrimeReportForm({super.key});

 @override
 State<CrimeReportForm> createState() => _CrimeReportFormState();
}

class _CrimeReportFormState extends State<CrimeReportForm> {
 final subjectController = TextEditingController();
 final crimeDescriptionController = TextEditingController();
 final dateController = TextEditingController();
 
 bool isLocationEnabled = false;

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.grey[300],
     body: SafeArea(
       child: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.symmetric(vertical: 20),
           child: Center(
             child: Column(
               children: [
                 const SizedBox(height: 10),

                 // logo
                 Image.asset(
                   'assets/logos/logo_silent_signal.png',
                   height: 100,
                   width: 100,
                 ),

                 const SizedBox(height: 30),

                 Text(
                   'CRIME FORM',
                   style: TextStyle(
                     color: Colors.grey[800],
                     fontSize: 20,
                     fontWeight: FontWeight.bold
                   ),
                 ),

                 const SizedBox(height: 25),

                 InputTextField(
                   controller: subjectController,
                   hintText: 'Theft',
                   obscureText: false,
                   labelText: 'Subject',
                 ),

                 const SizedBox(height: 10),

                 DateInputField(
                   controller: dateController,
                   hintText: 'Date of Crime',
                   labelText: 'Date of Crime',
                 ),

                 const SizedBox(height: 25),

                 InputTextField(
                   controller: crimeDescriptionController,
                   hintText: 'Provide a detailed description of the incident or crime',
                   obscureText: false,
                   minLines: 5,
                   maxLines: null,
                   labelText: 'Crime description',
                 ),

                 const SizedBox(height: 30),

                 Padding(
                   padding: const EdgeInsets.only(left: 25),
                   child: Row(
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             'Send Location(optional)',
                             style: TextStyle(
                               fontSize: 16,
                               color: Colors.grey[800],
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                           IconButton(
                             icon: Icon(
                               isLocationEnabled ? Icons.toggle_on : Icons.toggle_off,
                               color: isLocationEnabled ? Colors.blue : Colors.grey,
                               size: 70,
                             ),
                             onPressed: () {
                               setState(() {
                                 isLocationEnabled = !isLocationEnabled;
                               });
                             },
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
                
                 const SizedBox(height: 25),

                 SampleButton(
                   onTap: () {
                     // your onTap function
                   },
                   buttonText: "Next",
                   buttonColor: Colors.blue,
                   height: 35,
                 ),
               ],
             ),
           ),
         ),
       ),
     ),
   );
 }
}