// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:provider/provider.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:silentsignal/common/components/base_layout.dart';
// // import 'package:silentsignal/common/components/crime_details_form.dart';
// // import 'package:silentsignal/common/components/crime_file_upload.dart';
// // import 'package:silentsignal/common/validators/form_validator.dart';
// // import 'dart:io';
// // import 'package:silentsignal/services/api_service.dart';
// // import 'package:silentsignal/providers/user_provider.dart';
// // import 'package:silentsignal/common/components/crime_report_data.dart';


// // class CrimeReportForm extends StatefulWidget {
// //   const CrimeReportForm({super.key});

// //   @override
// //   State<CrimeReportForm> createState() => _CrimeReportFormState();
// // }

// // class _CrimeReportFormState extends State<CrimeReportForm> {
// //   final _pageController = PageController();
// //   final _formData = CrimeFormData();
// //   bool _showValidationErrors = false;
// //   List<dynamic> selectedFiles = [];



// //   FilePickerResult? result;
// //   String? _fileName;
// //   PlatformFile? pickedfile;
// //   bool isLoading = false;
// //   File? fileToDisplay;
// //   final passwordController = TextEditingController();
// //   String? passwordError;

// //   void pickFile() async {
// //     try {
// //       setState(() {
// //         // Start loading state
// //       });

// //       FilePickerResult? result = await FilePicker.platform.pickFiles(
// //         type: FileType.any, // Allows any file type (images, videos, docs, etc.)
// //         allowMultiple: true,
// //       );

// //       if (result != null) {
// //         setState(() {
// //           selectedFiles.addAll(result.files
// //               .where((file) => file.path != null)
// //               .map((file) => File(file.path!)));
// //         });
// //       }
// //     } catch (e) {
// //       print("Error picking file: $e");
// //     }
// //   }


// //   bool _isSubmitting = false;
  
// //   // First page controllers
// //   final subjectController = TextEditingController();
// //   final crimeDescriptionController = TextEditingController();
// //   final dateController = TextEditingController();
  
// //   // Error messages
// //   String? subjectError;
// //   String? descriptionError;
// //   String? dateError;


// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: PageView(
// //           controller: _pageController,
// //           physics: const NeverScrollableScrollPhysics(),
// //           children: [
// //             CrimeDetailsForm(
// //                subjectController: subjectController,
// //                 dateController: dateController,
// //                 crimeDescriptionController: crimeDescriptionController,
// //                 subjectError: subjectError,
// //                 dateError: dateError,
// //                 descriptionError: descriptionError,
// //                 showValidationErrors: _showValidationErrors,
// //                 isLocationEnabled: _formData.isLocationEnabled,
// //                 onToggleLocation: () async {
// //                   setState(() {
// //                     _formData.isLocationEnabled = !_formData.isLocationEnabled;
// //                   });

// //                   if (_formData.isLocationEnabled) {
// //                     await _getCurrentLocation();
// //                   } else {
// //                     _formData.latitude = null;
// //                     _formData.longitude = null;
// //                   }
// //                 },
// //                 onNext: _validateAndNavigateToSecondPage,
// //             ),
// //             _buildSecondPage(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// // Widget _buildSecondPage() {
// //   final userProvider = Provider.of<UserProvider>(context, listen: false);
// //   final bool isAnonymous = userProvider.user?['id'] == null;

// //   return FileUploadPage(
// //     selectedFiles: selectedFiles,
// //     onPickFile: pickFile,
// //     onPrevious: () {
// //       _pageController.previousPage(
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeInOut,
// //       );
// //     },
// //     onSubmit: _submitForm,
// //     pageController: _pageController,
// //     showPasswordField: isAnonymous,
// //     passwordController: passwordController,
// //   );
// // }


// //   void _validateAndNavigateToSecondPage() {
// //     setState(() {
// //       _showValidationErrors = true;
      
// //       // Validate each field
// //       subjectError = FormValidator.validateRequired(
// //         subjectController.text, 
// //         'Subject'
// //       );
// //       descriptionError = FormValidator.validateRequired(
// //         crimeDescriptionController.text, 
// //         'Crime description'
// //       );
// //       dateError = FormValidator.validateRequired(
// //         dateController.text, 
// //         'Date'
// //       );
// //     });

// //     // Check if all required fields are valid
// //     if (subjectError == null && 
// //         descriptionError == null && 
// //         dateError == null) {
// //       // Save first page data
// //       _formData.subject = subjectController.text;
// //       _formData.crimeDescription = crimeDescriptionController.text;
// //       _formData.date = dateController.text;
      
// //       // Navigate to second page
// //       _pageController.nextPage(
// //         duration: const Duration(milliseconds: 30),
// //         curve: Curves.easeInOut,
// //       );
// //     }
// //   }

// //     Future<void> _submitForm() async {
// //       setState(() {
// //     _isSubmitting = true;
// //   });
// //       Map<String, dynamic> requestData = {
// //         'subject_name': _formData.subject,
// //         'description': _formData.crimeDescription,
// //         'crime_type': _formData.subject,
// //         'crime_category': _formData.subject,
// //         'longitude': _formData.longitude ?? 0,
// //         'latitude': _formData.latitude ?? 0,    
// //         'status': "pending",
// //       };
// //       final userProvider = Provider.of<UserProvider>(context, listen: false);
// //       final userId = userProvider.user?['id'];
// //        if (userId != null) {
// //         requestData['user_id'] = userId;
// //       } else {
// //         // Generate a random password for anonymous reports
// //         requestData['password'] = passwordController;
// //         // Or you could ask user to provide a password
// //         // requestData['password'] = _formData.anonymousPassword; 
// //       }

// //       final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
// //     final response = await apiService.post(
// //       endpoint: '/crimeReports',  
// //       data: requestData,

// //     );
// //     print('Getting response');
// //     print(response);
// //     setState(() {
// //     _isSubmitting = false;
// //   });
// //   if (response != null && response['reference_token'] != null  ) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(15),
// //           ),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               const SizedBox(height: 15),
// //               Container(
// //                 width: 100,
// //                 height: 100,
// //                 decoration: const BoxDecoration(
// //                   color: Colors.green,
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: const Icon(
// //                   Icons.check,
// //                   color: Colors.white,
// //                   size: 60,
// //                 ),
// //               ),
// //               const SizedBox(height: 15),
// //               const Text(
// //                 'Your report has been submitted successfully.',
// //                 textAlign: TextAlign.center,
// //               ),
// //               const SizedBox(height: 20),
// //             const Text(
// //               'Reference Token:',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.grey,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[100],
// //                 borderRadius: BorderRadius.circular(8),
// //                 border: Border.all(color: Colors.grey[300]!),
// //               ),
// //               child: SelectableText(
// //                 response['reference_token'],
// //                 textAlign: TextAlign.center,
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black87,
// //                   letterSpacing: 1.2,
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 15),
// //             const Text(
// //               'Please save this reference token to track your report status.',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: Colors.grey,
// //                 fontStyle: FontStyle.italic,
// //               ),
// //             ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               child: const Text(
// //                 'OK',
// //                 style: TextStyle(color: Colors.green),
// //               ),
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Dismiss the dialog
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const BaseLayout()),
// //                 );
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );

// //   }

// //   }

// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //     subjectController.dispose();
// //     crimeDescriptionController.dispose();
// //     dateController.dispose();
// //     super.dispose();
// //   }
// //   Future<void> _getCurrentLocation() async {
// //   bool serviceEnabled;
// //   LocationPermission permission;

// //   // Check if location services are enabled
// //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //   if (!serviceEnabled) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text('Location services are disabled.')),
// //     );
// //     return;
// //   }

// //   // Check for permission
// //   permission = await Geolocator.checkPermission();
// //   if (permission == LocationPermission.denied) {
// //     permission = await Geolocator.requestPermission();
// //     if (permission == LocationPermission.denied) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Location permission denied.')),
// //       );
// //       return;
// //     }
// //   }

// //   if (permission == LocationPermission.deniedForever) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(content: Text('Location permissions are permanently denied.')),
// //     );
// //     return;
// //   }

// //   // Get current position
// //   final position = await Geolocator.getCurrentPosition(
// //     desiredAccuracy: LocationAccuracy.high,
// //   );

// //   setState(() {
// //     _formData.latitude = position.latitude;
// //     _formData.longitude = position.longitude;
// //   });
// // }

// // }

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:provider/provider.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:silentsignal/common/components/base_layout.dart';
// import 'package:silentsignal/common/components/crime_details_form.dart';
// import 'package:silentsignal/common/components/crime_file_upload.dart';
// import 'package:silentsignal/common/validators/form_validator.dart';
// import 'dart:io';
// import 'package:silentsignal/services/api_service.dart';
// import 'package:silentsignal/providers/user_provider.dart';
// import 'package:silentsignal/common/components/crime_report_data.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:async';
// import 'package:path_provider/path_provider.dart';

// class CrimeReportForm extends StatefulWidget {
//   const CrimeReportForm({super.key});

//   @override
//   State<CrimeReportForm> createState() => _CrimeReportFormState();
// }

// class _CrimeReportFormState extends State<CrimeReportForm> {
//   final _pageController = PageController();
//   final _formData = CrimeFormData();
//   bool _showValidationErrors = false;
//   List<dynamic> selectedFiles = [];

//   FilePickerResult? result;
//   String? _fileName;
//   PlatformFile? pickedfile;
//   bool isLoading = false;
//   File? fileToDisplay;
//   final passwordController = TextEditingController();
//   String? passwordError;

//   // Voice recording variables
//   FlutterSoundRecorder? _audioRecorder;
//   FlutterSoundPlayer? _audioPlayer;
//   bool _recorderIsInitialized = false;
//   bool _playerIsInitialized = false;
//   bool _isRecording = false;
//   bool _hasVoiceNote = false;
//   String? _voiceNotePath;
//   Timer? _recordingTimer;
//   Duration _recordingDuration = Duration.zero;

//   void pickFile() async {
//     try {
//       setState(() {
//         // Start loading state
//       });

//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.any, // Allows any file type (images, videos, docs, etc.)
//         allowMultiple: true,
//       );

//       if (result != null) {
//         setState(() {
//           selectedFiles.addAll(result.files
//               .where((file) => file.path != null)
//               .map((file) => File(file.path!)));
//         });
//       }
//     } catch (e) {
//       print("Error picking file: $e");
//     }
//   }

//   bool _isSubmitting = false;
  
//   // First page controllers
//   final subjectController = TextEditingController();
//   final crimeDescriptionController = TextEditingController();
//   final dateController = TextEditingController();
  
//   // Error messages
//   String? subjectError;
//   String? descriptionError;
//   String? dateError;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAudio();
//   }

//   Future<void> _initializeAudio() async {
//     _audioRecorder = FlutterSoundRecorder();
//     _audioPlayer = FlutterSoundPlayer();
    
//     await _audioRecorder!.openRecorder();
//     await _audioPlayer!.openPlayer();
    
//     await _requestMicrophonePermission();
    
//     setState(() {
//       _recorderIsInitialized = true;
//       _playerIsInitialized = true;
//     });
//   }

//   Future<void> _requestMicrophonePermission() async {
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Microphone permission is required for voice notes'),
//         ),
//       );
//     }
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (!_recorderIsInitialized) {
//         await _initializeAudio();
//       }

//       final hasPermission = await Permission.microphone.isGranted;
//       if (!hasPermission) {
//         await _requestMicrophonePermission();
//         return;
//       }

//       final directory = await getApplicationDocumentsDirectory();
//       final fileName = 'voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';
//       _voiceNotePath = '${directory.path}/$fileName';

//       await _audioRecorder!.startRecorder(
//         toFile: _voiceNotePath,
//         codec: Codec.aacADTS,
//       );

//       setState(() {
//         _isRecording = true;
//         _recordingDuration = Duration.zero;
//       });

//       _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         setState(() {
//           _recordingDuration = Duration(seconds: timer.tick);
//         });
//       });
//     } catch (e) {
//       print('Error starting recording: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to start recording: $e')),
//       );
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _audioRecorder!.stopRecorder();
//       _recordingTimer?.cancel();
      
//       setState(() {
//         _isRecording = false;
//         _hasVoiceNote = true;
//       });

//       // Add voice note to selected files
//       if (_voiceNotePath != null) {
//         final voiceFile = File(_voiceNotePath!);
//         if (await voiceFile.exists()) {
//           setState(() {
//             selectedFiles.add(voiceFile);
//           });
//         }
//       }
//     } catch (e) {
//       print('Error stopping recording: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to stop recording: $e')),
//       );
//     }
//   }

//   Future<void> _playVoiceNote() async {
//     try {
//       if (_voiceNotePath != null && _playerIsInitialized) {
//         await _audioPlayer!.startPlayer(
//           fromURI: _voiceNotePath,
//           codec: Codec.aacADTS,
//         );
//       }
//     } catch (e) {
//       print('Error playing voice note: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to play voice note: $e')),
//       );
//     }
//   }

//   Future<void> _deleteVoiceNote() async {
//     try {
//       if (_voiceNotePath != null) {
//         final file = File(_voiceNotePath!);
//         if (await file.exists()) {
//           await file.delete();
          
//           // Remove from selected files
//           setState(() {
//             selectedFiles.removeWhere((file) => 
//               file is File && file.path == _voiceNotePath);
//           });
//         }
//       }
      
//       setState(() {
//         _hasVoiceNote = false;
//         _voiceNotePath = null;
//         _recordingDuration = Duration.zero;
//       });
//     } catch (e) {
//       print('Error deleting voice note: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete voice note: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: PageView(
//           controller: _pageController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             CrimeDetailsForm(
//               subjectController: subjectController,
//               dateController: dateController,
//               crimeDescriptionController: crimeDescriptionController,
//               subjectError: subjectError,
//               dateError: dateError,
//               descriptionError: descriptionError,
//               showValidationErrors: _showValidationErrors,
//               isLocationEnabled: _formData.isLocationEnabled,
//               isRecording: _isRecording,
//               hasVoiceNote: _hasVoiceNote,
//               recordingDuration: _recordingDuration,
//               onToggleLocation: () async {
//                 setState(() {
//                   _formData.isLocationEnabled = !_formData.isLocationEnabled;
//                 });

//                 if (_formData.isLocationEnabled) {
//                   await _getCurrentLocation();
//                 } else {
//                   _formData.latitude = null;
//                   _formData.longitude = null;
//                 }
//               },
//               onStartRecording: _startRecording,
//               onStopRecording: _stopRecording,
//               onPlayVoiceNote: _playVoiceNote,
//               onDeleteVoiceNote: _deleteVoiceNote,
//               onNext: _validateAndNavigateToSecondPage,
//             ),
//             _buildSecondPage(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSecondPage() {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final bool isAnonymous = userProvider.user?['id'] == null;

//     return FileUploadPage(
//       selectedFiles: selectedFiles,
//       onPickFile: pickFile,
//       onPrevious: () {
//         _pageController.previousPage(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       },
//       onSubmit: _submitForm,
//       pageController: _pageController,
//       showPasswordField: isAnonymous,
//       passwordController: passwordController,
//     );
//   }

//   void _validateAndNavigateToSecondPage() {
//     setState(() {
//       _showValidationErrors = true;
      
//       // Validate each field
//       subjectError = FormValidator.validateRequired(
//         subjectController.text, 
//         'Subject'
//       );
//       descriptionError = FormValidator.validateRequired(
//         crimeDescriptionController.text, 
//         'Crime description'
//       );
//       dateError = FormValidator.validateRequired(
//         dateController.text, 
//         'Date'
//       );
//     });

//     // Check if all required fields are valid
//     if (subjectError == null && 
//         descriptionError == null && 
//         dateError == null) {
//       // Save first page data
//       _formData.subject = subjectController.text;
//       _formData.crimeDescription = crimeDescriptionController.text;
//       _formData.date = dateController.text;
      
//       // Navigate to second page
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 30),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   Future<void> _submitForm() async {
//     setState(() {
//       _isSubmitting = true;
//     });
    
//     Map<String, dynamic> requestData = {
//       'subject_name': _formData.subject,
//       'description': _formData.crimeDescription,
//       'crime_type': _formData.subject,
//       'crime_category': _formData.subject,
//       'longitude': _formData.longitude ?? 0,
//       'latitude': _formData.latitude ?? 0,    
//       'status': "pending",
//       'has_voice_note': _hasVoiceNote,
//     };
    
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final userId = userProvider.user?['id'];
    
//     if (userId != null) {
//       requestData['user_id'] = userId;
//     } else {
//       // Generate a random password for anonymous reports
//       requestData['password'] = passwordController.text;
//     }

//     final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
//     final response = await apiService.post(
//       endpoint: '/crimeReports',  
//       data: requestData,
//     );
    
//     print('Getting response');
//     print(response);
    
//     setState(() {
//       _isSubmitting = false;
//     });
    
//     if (response != null && response['reference_token'] != null) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const SizedBox(height: 15),
//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 60,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   'Your report has been submitted successfully${_hasVoiceNote ? ' with voice note' : ''}.',
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Reference Token:',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey[300]!),
//                   ),
//                   child: SelectableText(
//                     response['reference_token'],
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 const Text(
//                   'Please save this reference token to track your report status.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: const Text(
//                   'OK',
//                   style: TextStyle(color: Colors.green),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Dismiss the dialog
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const BaseLayout()),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     subjectController.dispose();
//     crimeDescriptionController.dispose();
//     dateController.dispose();
//     _audioRecorder?.closeRecorder();
//     _audioPlayer?.closePlayer();
//     _recordingTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location services are disabled.')),
//       );
//       return;
//     }

//     // Check for permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permission denied.')),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location permissions are permanently denied.')),
//       );
//       return;
//     }

//     // Get current position
//     final position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       _formData.latitude = position.latitude;
//       _formData.longitude = position.longitude;
//     });
//   }
// }


// lib/screens/crime_report_form.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/common/components/crime_details_form.dart';
import 'package:silentsignal/common/components/crime_file_upload.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/common/validators/form_validator.dart';
import 'dart:io';
import 'package:silentsignal/services/api_service.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/common/components/crime_report_data.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

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

  // Voice recording variables
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  bool _recorderIsInitialized = false;
  bool _playerIsInitialized = false;
  bool _isRecording = false;
  bool _hasVoiceNote = false;
  bool _isPlaying = false;
  String? _voiceNotePath;
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;

  // Form controllers
  final subjectController = TextEditingController();
  final crimeDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();

  // Error messages
  String? subjectError;
  String? descriptionError;
  String? dateError;
  String? locationError;
  String? crimeTypeError;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      _audioRecorder = FlutterSoundRecorder();
      _audioPlayer = FlutterSoundPlayer();
      
      await _audioRecorder!.openRecorder();
      await _audioPlayer!.openPlayer();
      
      await _requestMicrophonePermission();
      
      if (mounted) {
        setState(() {
          _recorderIsInitialized = true;
          _playerIsInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted && mounted) {
      _showSnackBar('Microphone permission is required for voice notes', Colors.orange);
    }
  }

  Future<void> _startRecording() async {
    try {
      if (!_recorderIsInitialized) {
        await _initializeAudio();
      }

      final hasPermission = await Permission.microphone.isGranted;
      if (!hasPermission) {
        await _requestMicrophonePermission();
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';
      _voiceNotePath = '${directory.path}/$fileName';

      await _audioRecorder!.startRecorder(
        toFile: _voiceNotePath,
        codec: Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingDuration = Duration(seconds: timer.tick);
          });
        }
      });
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        _showSnackBar('Failed to start recording: $e', Colors.red);
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder!.stopRecorder();
      _recordingTimer?.cancel();
      
      setState(() {
        _isRecording = false;
        _hasVoiceNote = true;
        _formData.voiceRecordingPath = _voiceNotePath;
      });

      if (_voiceNotePath != null) {
        final voiceFile = File(_voiceNotePath!);
        if (await voiceFile.exists()) {
          setState(() {
            selectedFiles.add(voiceFile);
          });
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
      if (mounted) {
        _showSnackBar('Failed to stop recording: $e', Colors.red);
      }
    }
  }

  Future<void> _playVoiceNote() async {
    try {
      if (_voiceNotePath != null && _playerIsInitialized) {
        setState(() {
          _isPlaying = true;
        });

        await _audioPlayer!.startPlayer(
          fromURI: _voiceNotePath,
          codec: Codec.aacADTS,
          whenFinished: () {
            if (mounted) {
              setState(() {
                _isPlaying = false;
              });
            }
          },
        );
      }
    } catch (e) {
      print('Error playing voice note: $e');
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
        _showSnackBar('Failed to play voice note: $e', Colors.red);
      }
    }
  }

  Future<void> _deleteVoiceNote() async {
    try {
      if (_voiceNotePath != null) {
        final file = File(_voiceNotePath!);
        if (await file.exists()) {
          await file.delete();
          
          setState(() {
            selectedFiles.removeWhere((file) => 
              file is File && file.path == _voiceNotePath);
          });
        }
      }
      
      setState(() {
        _hasVoiceNote = false;
        _voiceNotePath = null;
        _recordingDuration = Duration.zero;
        _formData.voiceRecordingPath = null;
      });
    } catch (e) {
      print('Error deleting voice note: $e');
      if (mounted) {
        _showSnackBar('Failed to delete voice note: $e', Colors.red);
      }
    }
  }

  Future<void> _submitQuickVoiceReport() async {
    if (!_hasVoiceNote) return;

    // Show password setup dialog for anonymous users
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?['id'];
    
    if (userId == null) {
      await _showPasswordSetupDialog(isQuickReport: true);
    } else {
      await _performQuickSubmission();
    }
  }

  Future<void> _performQuickSubmission() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?['id'];
      
      final quickReport = {
        'subject_name': 'Quick Voice Report - ${DateTime.now().toString().substring(0, 16)}',
        'description': 'Voice recording submitted via quick report. Detailed description available in audio.',
        'crime_type': 'other',
        'crime_category': 'quick_report',
        'location': 'Location to be specified later',
        'urgency_level': 'EMERGENCY',
        'longitude': _formData.longitude ?? 0,
        'latitude': _formData.latitude ?? 0,
        'status': 'PENDING',
        'anonymous_report': userId == null,
      };

      if (userId != null) {
        quickReport['user_id'] = userId;
      } else {
        quickReport['password'] = _formData.password ?? 'quick_${DateTime.now().millisecondsSinceEpoch}';
      }

      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      final response = await apiService.post(
        endpoint: '/crimeReports',
        data: quickReport,
      );

      if (response != null && response['reference_token'] != null) {
        _showSuccessDialog(response['reference_token'], isQuickReport: true);
      }
    } catch (e) {
      _showSnackBar('Failed to submit quick report: $e', Colors.red);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // Enhanced Password Setup Dialog
  Future<void> _showPasswordSetupDialog({bool isQuickReport = false}) async {
    final TextEditingController passwordDialogController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    String? passwordError;
    String? confirmPasswordError;
    bool showValidationErrors = false;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void validateAndSetPassword() {
              setDialogState(() {
                showValidationErrors = true;
                passwordError = null;
                confirmPasswordError = null;

                // Validate password
                if (passwordDialogController.text.isEmpty) {
                  passwordError = 'Password is required';
                } else if (passwordDialogController.text.length < 6) {
                  passwordError = 'Password must be at least 6 characters';
                } else if (passwordDialogController.text.length > 50) {
                  passwordError = 'Password too long (max 50 characters)';
                }

                // Validate confirm password
                if (confirmPasswordController.text.isEmpty) {
                  confirmPasswordError = 'Please confirm your password';
                } else if (passwordDialogController.text != confirmPasswordController.text) {
                  confirmPasswordError = 'Passwords do not match';
                }
              });

              // If validation passes, set password
              if (passwordError == null && confirmPasswordError == null) {
                setState(() {
                  _formData.password = passwordDialogController.text;
                });
                Navigator.of(dialogContext).pop();
                
                if (isQuickReport) {
                  _performQuickSubmission();
                } else {
                  _performRegularSubmission();
                }
              }
            }

            void skipPassword() {
              setState(() {
                _formData.password = 'anonymous_${DateTime.now().millisecondsSinceEpoch}';
              });
              Navigator.of(dialogContext).pop();
              
              if (isQuickReport) {
                _performQuickSubmission();
              } else {
                _performRegularSubmission();
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            color: Colors.blue[600],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Your Report',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                'Create a password to track your anonymous report',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),

                    // Information box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[600],
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Why create a password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Use your reference token + password to check report status\n• Provide additional information later if needed\n• Communicate with authorities while staying anonymous',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTextField(
                          controller: passwordDialogController,
                          hintText: 'Enter a secure password',
                          obscureText: true,
                          labelText: 'Create Password *',
                        ),
                        if (passwordError != null && showValidationErrors)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 5),
                            child: Text(
                              passwordError!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Confirm password field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm your password',
                          obscureText: true,
                          labelText: 'Confirm Password *',
                        ),
                        if (confirmPasswordError != null && showValidationErrors)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 5),
                            child: Text(
                              confirmPasswordError!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: validateAndSetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Create Password',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Warning text
                    Text(
                      'Remember: Save your reference token + password. You\'ll need both to track your report.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showSuccessDialog(String referenceToken, {bool isQuickReport = false}) {
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
              Text(
                isQuickReport
                    ? '🎙️ Emergency Voice Report Submitted!'
                    : '✅ Crime Report Submitted Successfully!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isQuickReport
                    ? 'Your voice report has been sent to authorities immediately.'
                    : 'Your detailed report${_hasVoiceNote ? ' with voice note' : ''} has been submitted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Case Reference:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      referenceToken,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_formData.password != null) ...[
                      Text(
                        'Use this reference + your password to track your report',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      Text(
                        'Save this reference to track your report',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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

  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
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
      _showSnackBar('Error picking file: $e', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Main form page with all web features
            CrimeDetailsForm(
              subjectController: subjectController,
              dateController: dateController,
              crimeDescriptionController: crimeDescriptionController,
              locationController: locationController,
              subjectError: subjectError,
              dateError: dateError,
              descriptionError: descriptionError,
              locationError: locationError,
              crimeTypeError: crimeTypeError,
              showValidationErrors: _showValidationErrors,
              selectedCrimeType: _formData.crimeType,
              selectedUrgencyLevel: _formData.urgencyLevel,
              onCrimeTypeChanged: (value) {
                setState(() {
                  _formData.crimeType = value;
                });
              },
              onUrgencyLevelChanged: (value) {
                setState(() {
                  _formData.urgencyLevel = value;
                });
              },
              isRecording: _isRecording,
              hasVoiceNote: _hasVoiceNote,
              isPlaying: _isPlaying,
              isSubmittingQuick: _isSubmitting,
              recordingDuration: _recordingDuration,
              onStartRecording: _startRecording,
              onStopRecording: _stopRecording,
              onPlayVoiceNote: _playVoiceNote,
              onDeleteVoiceNote: _deleteVoiceNote,
              onSubmitQuickVoiceReport: _submitQuickVoiceReport,
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
      showPasswordField: false, // We handle password in dialog now
      passwordController: passwordController,
    );
  }

  void _validateAndNavigateToSecondPage() {
    setState(() {
      _showValidationErrors = true;
      
      subjectError = FormValidator.validateRequired(
        subjectController.text, 
        'Incident title'
      );
      descriptionError = FormValidator.validateRequired(
        crimeDescriptionController.text, 
        'Description'
      );
      dateError = FormValidator.validateRequired(
        dateController.text, 
        'Date'
      );
      locationError = FormValidator.validateRequired(
        locationController.text, 
        'Location'
      );
      crimeTypeError = _formData.crimeType == null ? 'Please select a crime type' : null;
    });

    if (subjectError == null && 
        descriptionError == null && 
        dateError == null &&
        locationError == null &&
        crimeTypeError == null) {
      
      _formData.subject = subjectController.text;
      _formData.crimeDescription = crimeDescriptionController.text;
      _formData.date = dateController.text;
      _formData.location = locationController.text;
      
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitForm() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?['id'];
    
    // Show password dialog for anonymous users
    if (userId == null) {
      await _showPasswordSetupDialog(isQuickReport: false);
    } else {
      await _performRegularSubmission();
    }
  }

  Future<void> _performRegularSubmission() async {
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?['id'];
      
      final requestData = _formData.toApiRequest();
      
      if (userId != null) {
        requestData['user_id'] = userId;
      }

      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      final response = await apiService.post(
        endpoint: '/crimeReports',  
        data: requestData,
      );
      
      if (response != null && response['reference_token'] != null) {
        _showSuccessDialog(response['reference_token']);
      }
    } catch (e) {
      _showSnackBar('Failed to submit report: $e', Colors.red);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Location services are disabled.', Colors.orange);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permission denied.', Colors.orange);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied.', Colors.orange);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _formData.latitude = position.latitude;
        _formData.longitude = position.longitude;
      });

      _showSnackBar('📍 GPS location captured successfully', Colors.green);
    } catch (e) {
      _showSnackBar('Failed to get location: $e', Colors.red);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    subjectController.dispose();
    crimeDescriptionController.dispose();
    dateController.dispose();
    locationController.dispose();
    passwordController.dispose();
    _audioRecorder?.closeRecorder();
    _audioPlayer?.closePlayer();
    _recordingTimer?.cancel();
    super.dispose();
  }
}