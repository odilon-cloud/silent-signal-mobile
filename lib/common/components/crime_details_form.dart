// lib/crime_report/step_crime_info.dart

import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/datefield.dart';
import 'package:silentsignal/common/components/textfield.dart';

class CrimeDetailsForm extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController dateController;
  final TextEditingController crimeDescriptionController;
  final String? subjectError;
  final String? dateError;
  final String? descriptionError;
  final bool showValidationErrors;
  final bool isLocationEnabled;
  final VoidCallback onNext;
  final VoidCallback onToggleLocation;

  const CrimeDetailsForm({
    super.key,
    required this.subjectController,
    required this.dateController,
    required this.crimeDescriptionController,
    required this.subjectError,
    required this.dateError,
    required this.descriptionError,
    required this.showValidationErrors,
    required this.isLocationEnabled,
    required this.onNext,
    required this.onToggleLocation,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset('assets/logos/logo_silent_signal.png', height: 100, width: 100),
              const SizedBox(height: 25),
              Text(
                'CRIME FORM',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              /// Subject
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTextField(
                    controller: subjectController,
                    hintText: 'Theft',
                    obscureText: false,
                    labelText: 'Subject',
                  ),
                  if (subjectError != null && showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        subjectError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              /// Date of Crime
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateInputField(
                    controller: dateController,
                    hintText: 'Date of Crime',
                    labelText: 'Date of Crime',
                  ),
                  if (dateError != null && showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        dateError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              /// Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTextField(
                    controller: crimeDescriptionController,
                    hintText: 'Provide a detailed description of the incident or crime',
                    obscureText: false,
                    minLines: 5,
                    maxLines: null,
                    labelText: 'Crime description',
                  ),
                  if (descriptionError != null && showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        descriptionError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),

              /// Location toggle
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Send Location (optional)',
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
                          onPressed: onToggleLocation,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              /// Next button
              SampleButton(
                onTap: onNext,
                buttonText: "Next",
                buttonColor: Colors.blue,
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
