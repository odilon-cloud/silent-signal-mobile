import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/common/components/crime_details_form.dart';
import 'package:silentsignal/common/components/crime_file_upload.dart';
import 'package:silentsignal/common/validators/form_validator.dart';
import 'dart:io';
import 'package:silentsignal/services/api_service.dart';
import 'package:silentsignal/services/file_upload_service.dart';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/common/components/crime_report_data.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class CrimeReportForm extends StatefulWidget {
  const CrimeReportForm({super.key});

  @override
  State<CrimeReportForm> createState() => _CrimeReportFormState();
}

class _CrimeReportFormState extends State<CrimeReportForm> {
  final _pageController = PageController();
  final _formData = CrimeFormData();
  bool _showValidationErrors = false;
  List<File> selectedFiles = [];

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

  // Error messages
  String? subjectError;
  String? descriptionError;
  String? dateError;
  String? locationError;
  String? crimeTypeError;

  bool _isSubmitting = false;
  late FileUploadService _fileUploadService;

  @override
  void initState() {
    super.initState();
    _fileUploadService = FileUploadService(
      baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011',
    );
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
            selectedFiles.removeWhere((file) => file.path == _voiceNotePath);
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

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _performQuickSubmission();
    } catch (e) {
      _showSnackBar('Failed to submit quick report: $e', Colors.red);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _performQuickSubmission() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?['id'];
      
      // Upload voice recording to S3
      String? voiceUrl;
      String? mediaType;
      if (_voiceNotePath != null) {
        print('Quick submission - Starting voice recording upload...');
        voiceUrl = await _fileUploadService.uploadVoiceRecording(_voiceNotePath!);
        print('Quick submission - Voice recording upload result: $voiceUrl');
        if (voiceUrl == null) {
          throw Exception('Failed to upload voice recording');
        }
        // Get mediaType from uploadMultipleFiles to avoid accessing private _getContentType
        print('Quick submission - Getting media type...');
        final uploadResult = (await _fileUploadService.uploadMultipleFiles([File(_voiceNotePath!)]))[0];
        print('Quick submission - Media type result: ${uploadResult.isSuccess}');
        if (!uploadResult.isSuccess) {
          throw Exception('Failed to get media type for voice recording');
        }
        mediaType = uploadResult.mediaType;
      } else {
        print('Quick submission - No voice recording to upload');
      }

      final quickReport = {
        'voice_recording_url': voiceUrl,
        'urgency_level': UrgencyLevel.mapToBackend('high'),
        'is_emergency': true,
        'longitude': _formData.longitude ?? 0,
        'latitude': _formData.latitude ?? 0,
        'status': 'PENDING',
       // 'anonymous_report': userId == null,
      };

      if (userId != null) {
        quickReport['user_id'] = userId;
      }

      print('Quick submission - About to make API call...');
      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      print('Quick submission - API Base URL: ${dotenv.env['API_BASE_URL']}');
      print('Quick submission - Request data: $quickReport');
      final response = await apiService.post(
        endpoint: '/crimeReports/voice',
        data: quickReport,
      );
      print('Quick submission - Response: $response');

      if (response != null && response['reference_token'] != null) {
        // Upload voice recording metadata to backend
        if (voiceUrl != null && mediaType != null) {
          await _fileUploadService.uploadMediaInfo(
            response['id'],
            voiceUrl,
            mediaType,
          );
        }

        _showSuccessDialog(response['reference_token'], isQuickReport: true);
      }
    } catch (e) {
      throw Exception('Failed to submit quick report: $e');
    }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SelectableText(
                            referenceToken,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: referenceToken));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reference token copied to clipboard!'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.blue,
                            size: 20,
                          ),
                          tooltip: 'Copy reference token',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the copy icon to save this reference',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
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

  void pickCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          selectedFiles.add(File(photo.path));
        });
      }
    } catch (e) {
      print("Error picking camera: $e");
      _showSnackBar('Error taking photo: $e', Colors.red);
    }
  }

  void pickGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedFiles.add(File(image.path));
        });
      }
    } catch (e) {
      print("Error picking gallery: $e");
      _showSnackBar('Error picking from gallery: $e', Colors.red);
    }
  }

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
      onCamera: pickCamera,
      onGallery: pickGallery,
      onPrevious: () {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      onSubmit: _submitForm,
      pageController: _pageController,
      showPasswordField: false, // Password field removed for all users
      isSubmitting: _isSubmitting,
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
    setState(() {
      _isSubmitting = true;
    });

    try {
      await _performRegularSubmission();
    } catch (e) {
      _showSnackBar('Failed to submit report: $e', Colors.red);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _performRegularSubmission() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?['id'];
      
      // Upload files to S3
      final uploadResults = await _fileUploadService.uploadMultipleFiles(selectedFiles);
      final successfulUploads = uploadResults.where((result) => result.isSuccess).toList();

      final requestData = _formData.toApiRequest();
      
      if (userId != null) {
        requestData['user_id'] = userId;
      }  
      // } else {
      //   requestData['anonymous_report'] = true;
      // }

      final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
      print('Normal submission - API Base URL: ${dotenv.env['API_BASE_URL']}');
      print('Normal submission - Request data: $requestData');
      final response = await apiService.post(
        endpoint: '/crimeReports',  
        data: requestData,
      );
      print('Normal submission - Response: $response');
      
      if (response != null && response['reference_token'] != null) {
        // Upload media metadata to backend
        for (var result in successfulUploads) {
          await _fileUploadService.uploadMediaInfo(
            response['id'],
            result.filePath,
            result.mediaType,
          );
        }

        _showSuccessDialog(response['reference_token']);
        
        // Manually reset _formData
        setState(() {
          selectedFiles.clear();
          _formData.subject = null;
          _formData.crimeDescription = null;
          _formData.date = null;
          _formData.location = null;
          _formData.crimeType = null;
          _formData.urgencyLevel = null;
          _formData.latitude = null;
          _formData.longitude = null;
          _formData.voiceRecordingPath = null;
          subjectController.clear();
          crimeDescriptionController.clear();
          dateController.clear();
          locationController.clear();
          _hasVoiceNote = false;
          _voiceNotePath = null;
        });
      }
    } catch (e) {
      throw Exception('Failed to submit report: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    subjectController.dispose();
    crimeDescriptionController.dispose();
    dateController.dispose();
    locationController.dispose();
    _audioRecorder?.closeRecorder();
    _audioPlayer?.closePlayer();
    _recordingTimer?.cancel();
    super.dispose();
  }
}