import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/datefield.dart';
import 'package:silentsignal/common/components/textfield.dart';


// crime_form_data.dart
class CrimeFormData {
  String? subject;
  String? crimeDescription;
  String? date;
  bool isLocationEnabled;
  // Second page fields
  String? witnessName;
  String? witnessContact;
  String? evidenceDescription;
  
  CrimeFormData({
    this.subject,
    this.crimeDescription,
    this.date,
    this.isLocationEnabled = false,
    this.witnessName,
    this.witnessContact,
    this.evidenceDescription,
  });
}

class CrimeReportForm extends StatefulWidget {
  const CrimeReportForm({super.key});

  @override
  State<CrimeReportForm> createState() => _CrimeReportFormState();
}

class _CrimeReportFormState extends State<CrimeReportForm> {
  final _pageController = PageController();
  final _formData = CrimeFormData();
  
  // First page controllers
  final subjectController = TextEditingController();
  final crimeDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  
  // Second page controllers
  final witnessNameController = TextEditingController();
  final witnessContactController = TextEditingController();
  final evidenceDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(), // Disable swiping
          children: [
            _buildFirstPage(),
            _buildSecondPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),

              Image.asset(
                'assets/logos/logo_silent_signal.png',
                height: 100,
                width: 100,
              ),

              const SizedBox(height: 25),

              Text(
                'CRIME FORM',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 15),

              InputTextField(
                controller: subjectController,
                hintText: 'Theft',
                obscureText: false,
                labelText: 'Subject',
              ),

              const SizedBox(height: 15),

              DateInputField(
                controller: dateController,
                hintText: 'Date of Crime',
                labelText: 'Date of Crime',
              ),

              const SizedBox(height: 15),

              InputTextField(
                controller: crimeDescriptionController,
                hintText: 'Provide a detailed description of the incident or crime',
                obscureText: false,
                minLines: 5,
                maxLines: null,
                labelText: 'Crime description',
              ),

              const SizedBox(height: 20),

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
                            _formData.isLocationEnabled ? Icons.toggle_on : Icons.toggle_off,
                            color: _formData.isLocationEnabled ? Colors.blue : Colors.grey,
                            size: 70,
                          ),
                          onPressed: () {
                            setState(() {
                              _formData.isLocationEnabled = !_formData.isLocationEnabled;
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
                  // Save first page data
                  _formData.subject = subjectController.text;
                  _formData.crimeDescription = crimeDescriptionController.text;
                  _formData.date = dateController.text;
                  
                  // Navigate to second page
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
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

  Widget _buildSecondPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),

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

              const SizedBox(height: 50),

          Container(
  padding: const EdgeInsets.all(20),
  margin: const EdgeInsets.symmetric(horizontal: 40),
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.grey[300]!,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 2,
      blurRadius: 5,
      offset: Offset(0, 2),
    ),
  ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Upload An Attachment (optional)',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 10),  // Added spacing between text and icons

      Padding(
  padding: const EdgeInsets.symmetric(horizontal: 40), // Add padding around the Row
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        icon: Icon(
          Icons.camera_alt,
          color: Colors.blue,
          size: 30,
        ),
        onPressed: () {
        },
      ),
      IconButton(
        icon: Icon(
          Icons.attachment,
          color: Colors.blue,
          size: 30,
        ),
        onPressed: () {
        },
      ),
    ],
  ),
),
    ],
  ),
),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SampleButton(
                    onTap: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    buttonText: "Previous",
                    buttonColor: Colors.grey,
                    height: 35,
                  ),
                  
                  const SizedBox(width: 20),
                  
                  SampleButton(
                    onTap: () {
                      // Save second page data;
                      
                      // Here you can submit the complete form data
                      _submitForm();
                    },
                    buttonText: "Submit",
                    buttonColor: Colors.blue,
                    height: 35,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Here you can handle the form submission with all the data in _formData
    print('Submitting form with data:');
    print('Subject: ${_formData.subject}');
    print('Date: ${_formData.date}');
    print('Description: ${_formData.crimeDescription}');
    print('Location Enabled: ${_formData.isLocationEnabled}');
  
    
    // Add your API call or data processing here
  }

  @override
  void dispose() {
    _pageController.dispose();
    subjectController.dispose();
    crimeDescriptionController.dispose();
    dateController.dispose();
    witnessNameController.dispose();
    witnessContactController.dispose();
    evidenceDescriptionController.dispose();
    super.dispose();
  }
}