import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/datefield.dart';
import 'package:silentsignal/common/components/textfield.dart';


class CrimeReportForm extends StatelessWidget {
  CrimeReportForm({super.key});

  // text editing controllers
  final subjectController = TextEditingController();
  final passwordController = TextEditingController();
  final dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // logo
Image.asset(
  'assets/logos/logo_silent_signal.png', 
  height: 100,             
  width: 100,
),


              const SizedBox(height: 30),

              // welcome back, you've been missed!
              Text(
                'CRIME REPORT',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),
              //
              InputTextField(
                controller: subjectController,
                hintText: 'Theft',
               // labelText: 'Subject',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              DateInputField(
                controller: dateController,
                 //labelText: labelText,
                  hintText: 'Date of Crime'
            ),

              const SizedBox(height: 25),
              // Description textfield
              InputTextField(
                controller: passwordController,
                maxLines: null, // Allows the text field to expand vertically
                keyboardType: TextInputType.multiline
                //labelText: '',
                hintText: 'Provide a detailed description of the incident or crime',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // submit  button
              // SampleButton(
              //   onTap: UserSubmission,
              // ),

              const SizedBox(height: 50),


              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                
                ],
              ),

              const SizedBox(height: 50),

        
              
            ],
          ),
        ),
      ),
    );
  }
}