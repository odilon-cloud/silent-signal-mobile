

// import 'dart:io';
// import 'package:flutter/material.dart';

// class CrimeFormData {
//   String? subject;
//   String? crimeDescription;
//   String? date;
//   String? location;
//   String? crimeType;
//   String? urgencyLevel;
//   bool isLocationEnabled;
//   double? latitude;
//   double? longitude;
//   bool anonymousReport;
//   String? voiceRecordingPath;
//   List<File> mediaFiles;
//   String? password; // For anonymous reports

//   CrimeFormData({
//     this.subject,
//     this.crimeDescription,
//     this.date,
//     this.location,
//     this.crimeType,
//     this.urgencyLevel = 'MEDIUM',
//     this.isLocationEnabled = false,
//     this.latitude,
//     this.longitude,
//     this.anonymousReport = true,
//     this.voiceRecordingPath,
//     this.mediaFiles = const [],
//     this.password,
//   });

//   // Convert to API request format
//   Map<String, dynamic> toApiRequest() {
//     return {
//       'subject_name': subject,
//       'description': crimeDescription,
//       'crime_type': crimeType,
//       'crime_category': crimeType,
//       'location_address': location,
//       'urgency_level': urgencyLevel,
//       'longitude': longitude ?? 0,
//       'latitude': latitude ?? 0,
//       'status': "PENDING",
//      // 'has_voice_note': voiceRecordingPath != null,
//       //'anonymous_report': anonymousReport,a
//       //r'password': password,
//     };
//   }

//   // Validation
//   bool get isValid {
//     return subject != null && 
//            subject!.isNotEmpty && 
//            crimeDescription != null && 
//            crimeDescription!.isNotEmpty &&
//            date != null &&
//            date!.isNotEmpty &&
//            location != null &&
//            location!.isNotEmpty &&
//            crimeType != null &&
//            crimeType!.isNotEmpty;
//   }

//   // Reset form data
//   void reset() {
//     subject = null;
//     crimeDescription = null;
//     date = null;
//     location = null;
//     crimeType = null;
//     urgencyLevel = 'MEDIUM';
//     isLocationEnabled = false;
//     latitude = null;
//     longitude = null;
//     anonymousReport = true;
//     voiceRecordingPath = null;
//     mediaFiles = [];
//     password = null;
//   }
// }

// // Crime types matching web version
// class CrimeTypes {
//   static const List<String> types = [
//     'Theft',
//     'Assault', 
//     'Vandalism',
//     'Drug Activity',
//     'Fraud',
//     'Burglary',
//     'Harassment',
//     'Traffic Violations',
//     'Domestic Violence',
//     'Cyber Crime',
//     'Public Disturbance',
//     'Suspicious Activity',
//     'Other',
//   ];
// }

// // Urgency levels matching web version
// class UrgencyLevel {
//   final String value;
//   final String label;
//   final Color color;

//   const UrgencyLevel({
//     required this.value,
//     required this.label,
//     required this.color,
//   });

//   static const List<UrgencyLevel> levels = [
//     UrgencyLevel(
//       value: 'LOW',
//       label: 'Low Priority',
//       color: Colors.green,
//     ),
//     UrgencyLevel(
//       value: 'MEDIUM',
//       label: 'Medium Priority', 
//       color: Colors.orange,
//     ),
//     UrgencyLevel(
//       value: 'HIGH',
//       label: 'High Priority',
//       color: Colors.deepOrange,
//     ),
//     UrgencyLevel(
//       value: 'CRITICAL',
//       label: 'Emergency',
//       color: Colors.red,
//     ),
//   ];

//   static UrgencyLevel getByValue(String value) {
//     return levels.firstWhere(
//       (level) => level.value == value,
//       orElse: () => levels[1], // default to medium
//     );
//   }
// }

// lib/common/components/crime_report_data.dart

import 'dart:io';
import 'package:flutter/material.dart';

class CrimeFormData {
  String? subject;
  String? crimeDescription;
  String? date;
  String? location;
  String? crimeType;
  String? urgencyLevel;
  bool isLocationEnabled;
  double? latitude;
  double? longitude;
  bool anonymousReport;
  String? voiceRecordingPath;
  List<File> media;
  String? password; // For anonymous reports

  CrimeFormData({
    this.subject,
    this.crimeDescription,
    this.date,
    this.location,
    this.crimeType,
    this.urgencyLevel = 'medium', // Frontend value
    this.isLocationEnabled = false,
    this.latitude,
    this.longitude,
    this.anonymousReport = true,
    this.voiceRecordingPath,
    this.media = const [],
    this.password,
  });

  // Convert to API request format (matching your exact backend structure)
  Map<String, dynamic> toApiRequest({int? userId}) {
    // Map urgency level to backend format (matching your web mapUrgencyToBackend)
    String mapUrgencyToBackend(String frontendUrgency) {
      const mapping = {
        'low': 'LOW',
        'medium': 'MEDIUM', 
        'high': 'HIGH',
      };
      return mapping[frontendUrgency] ?? 'MEDIUM';
    }

    return {
      'subject_name': subject,
      'description': crimeDescription,
      'crime_type': crimeType,
      'crime_category': crimeType,
      'location_address': location,
      'is_anonymous': userId == null,
      'urgency_level': mapUrgencyToBackend(urgencyLevel ?? 'medium'),
      'voice_recording_url': voiceRecordingPath,
      'latitude': latitude,
      'longitude': longitude,
      'status': 'PENDING',
      'report_source': voiceRecordingPath != null 
          ? (subject != null && crimeDescription != null 
              ? 'MIXED' 
              : 'VOICE')
          : 'FORM',
      'is_emergency': urgencyLevel == 'emergency',
      'needs_completion': subject == null || 
                         crimeDescription == null || 
                         crimeType == null,
      'user_id': userId,
     // 'media': media,
       'has_media': false,
       'media_count': 0,
    };
  }

  // Validation
  bool get isValid {
    return subject != null && 
           subject!.isNotEmpty && 
           crimeDescription != null && 
           crimeDescription!.isNotEmpty &&
           date != null &&
           date!.isNotEmpty &&
           location != null &&
           location!.isNotEmpty &&
           crimeType != null &&
           crimeType!.isNotEmpty;
  }

  // Reset form data
  void reset() {
    subject = null;
    crimeDescription = null;
    date = null;
    location = null;
    crimeType = null;
    urgencyLevel = 'medium';
    isLocationEnabled = false;
    latitude = null;
    longitude = null;
    anonymousReport = true;
    voiceRecordingPath = null;
    media = [];
    password = null;

  }

  // Get human-readable urgency level
  String get urgencyLevelDisplay {
    switch (urgencyLevel?.toLowerCase()) {
      case 'low':
        return 'Low Priority';
      case 'medium':
        return 'Medium Priority';
      case 'high':
        return 'High Priority';
      case 'emergency':
        return 'Emergency';
      default:
        return 'Medium Priority';
    }
  }

  // Get human-readable crime type
  String get crimeTypeDisplay {
    if (crimeType == null) return 'Not specified';
    
    // Capitalize first letter and replace underscores with spaces
    return crimeType!
        .split('_')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  String toString() {
    return 'CrimeFormData{subject: $subject, crimeType: $crimeType, urgencyLevel: $urgencyLevel, hasVoice: ${voiceRecordingPath != null}, mediaCount: ${media.length}}';
  }
}

// Crime types matching your web version exactly
class CrimeTypes {
  static const List<String> types = [
    'Theft',
    'Assault', 
    'Vandalism',
    'Drug Activity',
    'Fraud',
    'Burglary',
    'Harassment',
    'Traffic Violations',
    'Domestic Violence',
    'Cyber Crime',
    'Public Disturbance',
    'Suspicious Activity',
    'Other',
  ];

  // For dropdown values (lowercase)
  static List<String> get values => types.map((type) => type.toLowerCase()).toList();
  
  // For display labels (original case)
  static List<String> get labels => types;
  
  // Convert display name to value
  static String getValueFromLabel(String label) {
    return label.toLowerCase();
  }
  
  // Convert value to display name
  static String getLabelFromValue(String value) {
    final index = values.indexOf(value);
    return index >= 0 ? types[index] : value;
  }
}

// Urgency levels matching your web version exactly
class UrgencyLevel {
  final String value;
  final String label;
  final Color color;

  const UrgencyLevel({
    required this.value,
    required this.label,
    required this.color,
  });

  static const List<UrgencyLevel> levels = [
    UrgencyLevel(
      value: 'low',
      label: 'Low Priority',
      color: Colors.green,
    ),
    UrgencyLevel(
      value: 'medium',
      label: 'Medium Priority', 
      color: Colors.orange,
    ),
    UrgencyLevel(
      value: 'high',
      label: 'High Priority',
      color: Colors.deepOrange,
    ),
    UrgencyLevel(
      value: 'emergency',
      label: 'Emergency',
      color: Colors.red,
    ),
  ];

  static UrgencyLevel getByValue(String value) {
    return levels.firstWhere(
      (level) => level.value == value,
      orElse: () => levels[1], // default to medium
    );
  }

  // Backend mapping (same as your web mapUrgencyToBackend function)
  static String mapToBackend(String frontendValue) {
    const mapping = {
      'low': 'LOW',
      'medium': 'MEDIUM', 
      'high': 'HIGH',
      'emergency': 'CRITICAL'
    };
    return mapping[frontendValue] ?? 'MEDIUM';
  }
}