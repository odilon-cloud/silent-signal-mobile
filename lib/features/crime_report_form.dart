import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/datefield.dart';
import 'package:silentsignal/common/components/textfield.dart';

class CrimeReportForm extends StatelessWidget {
  CrimeReportForm({super.key});

  final subjectController = TextEditingController();
  final crimeDescriptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView( // Added SingleChildScrollView
          child: Padding( // Added Padding for better spacing
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
                    maxLines:null,
                    labelText: 'Crime description',
                  ),

                  const SizedBox(height: 30),

                  SampleButton(
                    onTap: () {
                      // your onTap function
                    },
                    buttonText: "Continue",  // or any other text you want
                  ),


                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}