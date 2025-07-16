import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/datefield.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/common/components/crime_report_data.dart';
import 'package:silentsignal/common/components/map_selector.dart';

class CrimeDetailsForm extends StatefulWidget {
  final TextEditingController subjectController;
  final TextEditingController dateController;
  final TextEditingController crimeDescriptionController;
  final TextEditingController locationController;
  final String? subjectError;
  final String? dateError;
  final String? descriptionError;
  final String? locationError;
  final String? crimeTypeError;
  final bool showValidationErrors;
  final VoidCallback onNext;
  
  // Crime type and urgency
  final String? selectedCrimeType;
  final String? selectedUrgencyLevel;
  final Function(String?) onCrimeTypeChanged;
  final Function(String?) onUrgencyLevelChanged;
  
  // Voice recording parameters
  final bool isRecording;
  final bool hasVoiceNote;
  final bool isPlaying;
  final bool isSubmittingQuick;
  final Duration? recordingDuration;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onPlayVoiceNote;
  final VoidCallback onDeleteVoiceNote;
  final VoidCallback onSubmitQuickVoiceReport;

  // Location callback
  final Function(double lat, double lng, String address)? onLocationSelected;

  const CrimeDetailsForm({
    super.key,
    required this.subjectController,
    required this.dateController,
    required this.crimeDescriptionController,
    required this.locationController,
    this.subjectError,
    this.dateError,
    this.descriptionError,
    this.locationError,
    this.crimeTypeError,
    required this.showValidationErrors,
    required this.onNext,
    this.selectedCrimeType,
    this.selectedUrgencyLevel,
    required this.onCrimeTypeChanged,
    required this.onUrgencyLevelChanged,
    this.isRecording = false,
    this.hasVoiceNote = false,
    this.isPlaying = false,
    this.isSubmittingQuick = false,
    this.recordingDuration,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onPlayVoiceNote,
    required this.onDeleteVoiceNote,
    required this.onSubmitQuickVoiceReport,
    this.onLocationSelected,
  });

  @override
  State<CrimeDetailsForm> createState() => _CrimeDetailsFormState();
}

class _CrimeDetailsFormState extends State<CrimeDetailsForm> {
  bool _showLocationHelp = false;
  bool _showMapSelector = false;
  
  // Selected location data (for Leaflet map)
  LatLng? _selectedMapLocation;
  String? _selectedAddress;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // Handle location selection from the map
  void _handleLocationSelect(double lat, double lng, String address) {
    setState(() {
      _selectedMapLocation = LatLng(lat, lng);
      _selectedAddress = address;
    });
    
    // Update the location text field
    widget.locationController.text = address;
    
    // Call the callback if provided
    widget.onLocationSelected?.call(lat, lng, address);
  }

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
                'CRIME REPORT FORM',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Help keep your community safe',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // Quick Voice Report Section (Emergency Feature)
              _buildQuickVoiceReportSection(context),
              
              const SizedBox(height: 20),
              
              // Divider
              _buildDivider(),
              
              const SizedBox(height: 20),

              // Incident Details Section
              _buildSectionHeader('Incident Details', Icons.description),
              const SizedBox(height: 15),

              /// Subject/Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTextField(
                    controller: widget.subjectController,
                    hintText: 'Brief title of the incident',
                    obscureText: false,
                    labelText: 'Incident Title *',
                  ),
                  if (widget.subjectError != null && widget.showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        widget.subjectError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              /// Crime Type Dropdown
              _buildCrimeTypeDropdown(),
              const SizedBox(height: 15),

              /// Urgency Level Dropdown
             // _buildUrgencyLevelDropdown(),
              const SizedBox(height: 15),

              /// Date of Crime
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateInputField(
                    controller: widget.dateController,
                    hintText: 'When did this happen?',
                    labelText: 'Date of Incident *',
                  ),
                  if (widget.dateError != null && widget.showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        widget.dateError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              _buildLocationSection(),
              
              const SizedBox(height: 20),

              /// Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputTextField(
                    controller: widget.crimeDescriptionController,
                    hintText: 'Provide detailed information about what you witnessed or experienced...',
                    obscureText: false,
                    minLines: 5,
                    maxLines: null,
                    labelText: 'What happened? *',
                  ),
                  if (widget.descriptionError != null && widget.showValidationErrors)
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 5),
                      child: Text(
                        widget.descriptionError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 5),
                    child: Text(
                      'Include when it happened, who was involved, and any other relevant details',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              /// Privacy Notice
              _buildPrivacyNotice(),
              const SizedBox(height: 25),

              /// Next button
              SampleButton(
                onTap: widget.onNext,
                buttonText: "Continue to Evidence Upload",
                buttonColor: Colors.blue,
                height: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Location *',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _showLocationHelp = !_showLocationHelp),
                icon: Icon(
                  _showLocationHelp ? Icons.visibility_off : Icons.visibility,
                  color: Colors.blue[600],
                ),
                tooltip: _showLocationHelp ? 'Hide help' : 'Show help',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Location input field
        InputTextField(
            controller: widget.locationController,
            hintText: 'Street address, intersection, or landmark',
            obscureText: false,
        ),
        
        
        // Location error
        if (widget.locationError != null && widget.showValidationErrors)
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5),
            child: Text(
              widget.locationError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        
        // Location help text
        if (_showLocationHelp)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              'Be as specific as possible. Examples: "123 Main St", "Corner of 1st & Oak", "Central Park near playground"',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 12,
              ),
            ),
          ),
        
        const SizedBox(height: 15),
        
        // Map section directly below
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              //Icon(Icons.map, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => setState(() => _showMapSelector = !_showMapSelector),
                icon: Icon(_showMapSelector ? Icons.map_outlined : Icons.map),
                label: Text(_showMapSelector ? 'Hide Map' : 'Select on Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 5, right: 25),
          child: Text(
            'Use the map to pinpoint the exact location and help authorities respond faster',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        
        // Selected location display
        if (_selectedMapLocation != null && _selectedAddress != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precise Location Selected:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        _selectedAddress!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        'Coordinates: ${_selectedMapLocation!.latitude.toStringAsFixed(6)}, ${_selectedMapLocation!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedMapLocation = null;
                      _selectedAddress = null;
                    });
                    // Don't clear the main location field, just the precise location
                    widget.onLocationSelected?.call(0, 0, '');
                  },
                  icon: Icon(Icons.clear, color: Colors.green[600], size: 18),
                  tooltip: 'Clear precise location',
                ),
              ],
            ),
          ),
        
        // Map selector
        if (_showMapSelector)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            child: MapSelector(
              onLocationSelect: _handleLocationSelect,
              initialLocation: _selectedMapLocation,
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickVoiceReportSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[50]!, Colors.orange[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.red[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Voice Report',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Emergency? Record quickly and submit immediately.',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          if (!widget.hasVoiceNote) ...[
            // Recording button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.isRecording ? widget.onStopRecording : widget.onStartRecording,
                icon: Icon(
                  widget.isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
                label: Text(
                  widget.isRecording 
                      ? 'Stop Recording (${widget.recordingDuration != null ? _formatDuration(widget.recordingDuration!) : "00:00"})'
                      : 'Start Voice Report',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isRecording ? Colors.red : Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            if (widget.isRecording) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recording in progress...',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            // Voice note recorded
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.audiotrack, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Voice recording saved (${widget.recordingDuration != null ? _formatDuration(widget.recordingDuration!) : "00:00"})',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.isPlaying ? null : widget.onPlayVoiceNote,
                        icon: Icon(
                          widget.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: widget.isPlaying ? Colors.grey : Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onDeleteVoiceNote,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onDeleteVoiceNote,
                          icon: const Icon(Icons.mic, size: 18),
                          label: const Text('Record Again'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.isSubmittingQuick ? null : widget.onSubmitQuickVoiceReport,
                          icon: Icon(
                            widget.isSubmittingQuick ? Icons.hourglass_empty : Icons.send,
                            size: 18,
                          ),
                          label: Text(widget.isSubmittingQuick ? 'Submitting...' : 'Submit Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.isSubmittingQuick ? Colors.grey : Colors.red[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCrimeTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crime Type *',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              value: widget.selectedCrimeType,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'Select the type of crime',
              ),
              items: CrimeTypes.types.map((String type) {
                return DropdownMenuItem<String>(
                  value: type.toLowerCase(),
                  child: Text(type),
                );
              }).toList(),
              onChanged: widget.onCrimeTypeChanged,
            ),
          ),
          if (widget.crimeTypeError != null && widget.showValidationErrors)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                widget.crimeTypeError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUrgencyLevelDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority Level *',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<String>(
              value: widget.selectedUrgencyLevel,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'Select priority level',
              ),
              items: UrgencyLevel.levels.map((UrgencyLevel level) {
                return DropdownMenuItem<String>(
                  value: level.value,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: level.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: level.color.withOpacity(0.3)),
                        ),
                        child: Text(
                          level.label,
                          style: TextStyle(
                            color: level.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: widget.onUrgencyLevelChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Emergency reports are forwarded immediately',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield,
            color: Colors.blue[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Anonymous Reporting',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Text(
                  'This report will be submitted anonymously. Your personal information will not be shared unless you choose to provide it.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[400])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'OR FILL DETAILED REPORT',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[400])),
        ],
      ),
    );
  }
}