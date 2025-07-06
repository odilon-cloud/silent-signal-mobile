// class CrimeFormData {
//   String? subject;
//   String? crimeDescription;
//   String? date;
//   bool isLocationEnabled;
//   double? latitude;
//   double? longitude;

  
//   CrimeFormData({
//     this.subject,
//     this.crimeDescription,
//     this.date,
//     this.isLocationEnabled = false,
//     this.latitude,
//     this.longitude,
//   });
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
  List<File> mediaFiles;
  String? password; // For anonymous reports

  CrimeFormData({
    this.subject,
    this.crimeDescription,
    this.date,
    this.location,
    this.crimeType,
    this.urgencyLevel = 'MEDIUM',
    this.isLocationEnabled = false,
    this.latitude,
    this.longitude,
    this.anonymousReport = true,
    this.voiceRecordingPath,
    this.mediaFiles = const [],
    this.password,
  });

  // Convert to API request format
  Map<String, dynamic> toApiRequest() {
    return {
      'subject_name': subject,
      'description': crimeDescription,
      'crime_type': crimeType,
      'crime_category': crimeType,
      'location_address': location,
      'urgency_level': urgencyLevel,
      'longitude': longitude ?? 0,
      'latitude': latitude ?? 0,
      'status': "PENDING",
      'has_voice_note': voiceRecordingPath != null,
      'anonymous_report': anonymousReport,
      'password': password,
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
    urgencyLevel = 'MEDIUM';
    isLocationEnabled = false;
    latitude = null;
    longitude = null;
    anonymousReport = true;
    voiceRecordingPath = null;
    mediaFiles = [];
    password = null;
  }
}

// Crime types matching web version
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
}

// Urgency levels matching web version
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
      value: 'LOW',
      label: 'Low Priority',
      color: Colors.green,
    ),
    UrgencyLevel(
      value: 'MEDIUM',
      label: 'Medium Priority', 
      color: Colors.orange,
    ),
    UrgencyLevel(
      value: 'HIGH',
      label: 'High Priority',
      color: Colors.deepOrange,
    ),
    UrgencyLevel(
      value: 'CRITICAL',
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
}