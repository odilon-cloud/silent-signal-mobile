import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/common/components/crime_details_form.dart';
import 'package:silentsignal/common/components/crime_file_upload.dart';
import 'package:silentsignal/common/validators/form_validator.dart';
import 'dart:io';
import 'package:silentsignal/services/api_service.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/common/components/crime_report_data.dart';


class CrimeReportForm extends StatefulWidget {
  const CrimeReportForm({super.key});

  @override
  State<CrimeReportForm> createState() => _CrimeReportFormState();
}

class _CrimeReportFormState extends State<CrimeReportForm> {
  final _pageController = PageController();
  final _formData = CrimeFormData();
  bool _showValidationErrors = false;
  List<dynamic> selectedFiles = [];



  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;
  final passwordController = TextEditingController();
  String? passwordError;

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


  bool _isSubmitting = false;
  
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
            CrimeDetailsForm(
               subjectController: subjectController,
                dateController: dateController,
                crimeDescriptionController: crimeDescriptionController,
                subjectError: subjectError,
                dateError: dateError,
                descriptionError: descriptionError,
                showValidationErrors: _showValidationErrors,
                isLocationEnabled: _formData.isLocationEnabled,
                onToggleLocation: () async {
                  setState(() {
                    _formData.isLocationEnabled = !_formData.isLocationEnabled;
                  });

                  if (_formData.isLocationEnabled) {
                    await _getCurrentLocation();
                  } else {
                    _formData.latitude = null;
                    _formData.longitude = null;
                  }
                },
                onNext: _validateAndNavigateToSecondPage,
            ),
            _buildSecondPage(),
          ],
        ),
      ),
    );
  }

Widget _buildSecondPage() {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final bool isAnonymous = userProvider.user?['id'] == null;

  return FileUploadPage(
    selectedFiles: selectedFiles,
    onPickFile: pickFile,
    onPrevious: () {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    },
    onSubmit: _submitForm,
    pageController: _pageController,
    showPasswordField: isAnonymous,
    passwordController: passwordController,
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
      setState(() {
    _isSubmitting = true;
  });
      Map<String, dynamic> requestData = {
        'subject_name': _formData.subject,
        'description': _formData.crimeDescription,
        'crime_type': _formData.subject,
        'crime_category': _formData.subject,
        'longitude': _formData.longitude ?? 0,
        'latitude': _formData.latitude ?? 0,    
        'status': "pending",
      };
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?['id'];
       if (userId != null) {
        requestData['user_id'] = userId;
      } else {
        // Generate a random password for anonymous reports
        requestData['password'] = passwordController;
        // Or you could ask user to provide a password
        // requestData['password'] = _formData.anonymousPassword; 
      }

      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
    final response = await apiService.post(
      endpoint: '/crimeReports',  
      data: requestData,

    );
    print('Getting response');
    print(response);
    setState(() {
    _isSubmitting = false;
  });
  if (response != null && response['reference_token'] != null  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Your report has been submitted successfully.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            const Text(
              'Reference Token:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                response['reference_token'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Please save this reference token to track your report status.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
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
  Future<void> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location services are disabled.')),
    );
    return;
  }

  // Check for permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location permissions are permanently denied.')),
    );
    return;
  }

  // Get current position
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  setState(() {
    _formData.latitude = position.latitude;
    _formData.longitude = position.longitude;
  });
}

}
