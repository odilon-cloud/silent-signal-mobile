import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/datefield.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/common/validators/form_validator.dart';
import 'dart:io';
import 'package:silentsignal/services/api_service.dart';

class CrimeFormData {
  String? subject;
  String? crimeDescription;
  String? date;
  bool isLocationEnabled;
  
  CrimeFormData({
    this.subject,
    this.crimeDescription,
    this.date,
    this.isLocationEnabled = false,
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
  bool _showValidationErrors = false;
  List<dynamic> selectedFiles = []; // Stores both images and documents



  //File uploading section
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        // Start loading state
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Allows any file type (images, videos, docs, etc.)
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          selectedFiles.addAll(result.files
              .where((file) => file.path != null)
              .map((file) => File(file.path!)));
        });
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }


  // First page controllers
  final subjectController = TextEditingController();
  final crimeDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  
  // Error messages
  String? subjectError;
  String? descriptionError;
  String? dateError;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTextField(
                    controller: subjectController,
                    hintText: 'Theft',
                    obscureText: false,
                    labelText: 'Subject',
                  ),
                  if (subjectError != null && _showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        subjectError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateInputField(
                    controller: dateController,
                    hintText: 'Date of Crime',
                    labelText: 'Date of Crime',
                  ),
                  if (dateError != null && _showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        dateError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 15),

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
                  if (descriptionError != null && _showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        descriptionError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Location toggle section...
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
                onTap: _validateAndNavigateToSecondPage,
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
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

                  const SizedBox(height: 10),

                  // 📌 Display Uploaded Files (Stacked & Inside Shadow Box)
                  if (selectedFiles.isNotEmpty)
                    Column(
                      children: selectedFiles.map((file) {
                        String fileName = file.path.split('/').last;

                        // Limit filename to avoid UI breaking
                        String displayName = fileName.length > 20
                            ? "${fileName.substring(0, 10)}...${fileName.substring(fileName.length - 8)}"
                            : fileName;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: file.path.endsWith('.jpg') ||
                                  file.path.endsWith('.png') ||
                                  file.path.endsWith('.jpeg')
                              ? Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      file,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 250,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.insert_drive_file, color: Colors.blue, size: 30),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          displayName,
                                          style: const TextStyle(fontSize: 14, color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 15),

                  // 📌 **Centered Camera & Attachment Icons**
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.blue, size: 40),
                        onPressed: pickFile,
                      ),
                      const SizedBox(width: 20), // Space between icons
                      IconButton(
                        icon: const Icon(Icons.attachment, color: Colors.blue, size: 40),
                        onPressed: pickFile,
                      ),
                    ],
                  ),
                ],
              ),
            ), // 🏛 End of Bordered Shadow Box

            const SizedBox(height: 20),

            // 📌 **Previous & Submit Buttons**
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔙 Previous Button
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600], // Gray color like in the image
                    minimumSize: const Size(130, 50),
                  ),
                  child: const Text(
                    "Previous",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                const SizedBox(width: 20), // Space between buttons

                // ✅ Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(130, 50),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}




  void _validateAndNavigateToSecondPage() {
    setState(() {
      _showValidationErrors = true;
      
      // Validate each field
      subjectError = FormValidator.validateRequired(
        subjectController.text, 
        'Subject'
      );
      descriptionError = FormValidator.validateRequired(
        crimeDescriptionController.text, 
        'Crime description'
      );
      dateError = FormValidator.validateRequired(
        dateController.text, 
        'Date'
      );
    });

    // Check if all required fields are valid
    if (subjectError == null && 
        descriptionError == null && 
        dateError == null) {
      // Save first page data
      _formData.subject = subjectController.text;
      _formData.crimeDescription = crimeDescriptionController.text;
      _formData.date = dateController.text;
      
      // Navigate to second page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 30),
        curve: Curves.easeInOut,
      );
    }
  }

    Future<void> _submitForm() async {

      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
  final response = await apiService.post(
    endpoint: '/crimeReports',  
    data: {
      'subject_name': _formData.subject,
      'description': _formData.crimeDescription,
      'crime_type': _formData.subject,
      'crime_category': _formData.subject,
      'longitude': 0,
      'latitude': 0,
      'status': "pending",
      'user_id': 1,
  
    },

  );
  print(response);
  if (response != null && response['reference_token'] != null  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // title: Row(
          //   children: [
          //     Icon(
          //       Icons.check_circle,
          //       color: Colors.green,
          //       size: 28,
          //     ),
          //     SizedBox(width: 10),
          //     Text('Success'),
          //   ],
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Your report has been submitted successfully.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BaseLayout()),
                );
              },
            ),
          ],
        );
        // return AlertDialog(
        //   title: const Text('Report Submitted'),
        //   content: const Text('Your report has beensubmitted successfully. You will be redirected to the Home page.'),
        //   actions: [
        //     TextButton(
        //       child: const Text('OK'),
        //       onPressed: () {
        //         Navigator.of(context).pop(); // Dismiss the dialog
        //         Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(builder: (context) => const BaseLayout()),
        //         );
        //       },
        //     ),
        //   ],
        // );
      },
    );

  }

  }

  @override
  void dispose() {
    _pageController.dispose();
    subjectController.dispose();
    crimeDescriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
