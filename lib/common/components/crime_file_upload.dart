// import 'package:flutter/material.dart';
// import 'package:silentsignal/common/components/textfield.dart';

// class FileUploadPage extends StatefulWidget {
//   final List<dynamic> selectedFiles;
//   final VoidCallback onPickFile;
//   final VoidCallback onPrevious;
//   final VoidCallback onSubmit;
//   final PageController pageController;
//   final bool showPasswordField;
//   final TextEditingController? passwordController;

//   const FileUploadPage({
//     Key? key,
//     required this.selectedFiles,
//     required this.onPickFile,
//     required this.onPrevious,
//     required this.onSubmit,
//     required this.pageController,
//     this.showPasswordField = false,
//     this.passwordController,
//   }) : super(key: key);

//   @override
//   State<FileUploadPage> createState() => _FileUploadPageState();
// }

// class _FileUploadPageState extends State<FileUploadPage> {
//   String? passwordError;
//   bool showValidationErrors = false;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               Text(
//                 'CRIME FORM',
//                 style: TextStyle(
//                   color: Colors.grey[800],
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // Password field for anonymous users
//               if (widget.showPasswordField) ...[
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   margin: const EdgeInsets.symmetric(horizontal: 40),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.grey[300]!,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Set Password for Anonymous Report',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[800],
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Create a password to track your report status later',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       InputTextField(
//                         controller: widget.passwordController,
//                         hintText: 'password',
//                         obscureText: true,
//                         labelText: 'Password *',
//                       ),
//                       if (passwordError != null && showValidationErrors)
//                         Padding(
//                           padding: const EdgeInsets.only(left: 25, top: 5),
//                           child: Text(
//                             passwordError!,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],

//               Container(
//                 padding: const EdgeInsets.all(20),
//                 margin: const EdgeInsets.symmetric(horizontal: 40),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.grey[300]!,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Upload An Attachment (optional)',
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: Colors.grey[800],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     // 📌 Display Uploaded Files (Stacked & Inside Shadow Box)
//                     if (widget.selectedFiles.isNotEmpty)
//                       Column(
//                         children: widget.selectedFiles.map((file) {
//                           String fileName = file.path.split('/').last;

//                           // Limit filename to avoid UI breaking
//                           String displayName = fileName.length > 20
//                               ? "${fileName.substring(0, 10)}...${fileName.substring(fileName.length - 8)}"
//                               : fileName;

//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 5),
//                             child: file.path.endsWith('.jpg') ||
//                                     file.path.endsWith('.png') ||
//                                     file.path.endsWith('.jpeg')
//                                 ? Container(
//                                     width: 150,
//                                     height: 150,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(color: Colors.grey),
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.file(
//                                         file,
//                                         width: 150,
//                                         height: 150,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                   )
//                                 : Container(
//                                     width: 250,
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey),
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.2),
//                                           spreadRadius: 2,
//                                           blurRadius: 5,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         const Icon(Icons.insert_drive_file, color: Colors.blue, size: 30),
//                                         const SizedBox(width: 10),
//                                         Expanded(
//                                           child: Text(
//                                             displayName,
//                                             style: const TextStyle(fontSize: 14, color: Colors.black),
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                           );
//                         }).toList(),
//                       ),

//                     const SizedBox(height: 15),

//                     // 📌 **Centered Camera & Attachment Icons**
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.camera_alt, color: Colors.blue, size: 40),
//                           onPressed: widget.onPickFile,
//                         ),
//                         const SizedBox(width: 20), // Space between icons
//                         IconButton(
//                           icon: const Icon(Icons.attachment, color: Colors.blue, size: 40),
//                           onPressed: widget.onPickFile,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ), 

//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // 🔙 Previous Button
//                   ElevatedButton(
//                     onPressed: widget.onPrevious,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[600], // Gray color like in the image
//                       minimumSize: const Size(130, 50),
//                     ),
//                     child: const Text(
//                       "Previous",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),

//                   const SizedBox(width: 20), // Space between buttons

//                   // ✅ Submit Button
//                   ElevatedButton(
//                     onPressed: _validateAndSubmit,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       minimumSize: const Size(130, 50),
//                     ),
//                     child: const Text(
//                       "Submit",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _validateAndSubmit() {
//     FocusScope.of(context).unfocus();
    
//     // Only validate password if password field is shown
//     if (widget.showPasswordField && widget.passwordController != null) {
//       setState(() {
//         showValidationErrors = true;

//         // Validate password
//         if (widget.passwordController!.text.isEmpty) {
//           passwordError = 'Password is required';
//         } else if (widget.passwordController!.text.length < 6) {
//           passwordError = 'Password must be at least 6 characters long';
//         } else {
//           passwordError = null;
//         }
//       });

//       // If password validation fails, don't proceed
//       if (passwordError != null) {
//         return;
//       }
//     }

//     // If validation passes or no password field, proceed with submit
//     widget.onSubmit();
//   }
// }


// lib/common/components/crime_file_upload.dart

import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'dart:io';

class FileUploadPage extends StatefulWidget {
  final List<dynamic> selectedFiles;
  final VoidCallback onPickFile;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final PageController pageController;
  final bool showPasswordField;
  final TextEditingController? passwordController;
  final bool isSubmitting;

  const FileUploadPage({
    Key? key,
    required this.selectedFiles,
    required this.onPickFile,
    required this.onCamera,
    required this.onGallery,
    required this.onPrevious,
    required this.onSubmit,
    required this.pageController,
    this.showPasswordField = false,
    this.passwordController,
    this.isSubmitting = false,
  }) : super(key: key);

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  String? passwordError;
  bool showValidationErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                _buildHeader(),
                
                const SizedBox(height: 30),

                // Password field for anonymous users (if needed)
                if (widget.showPasswordField) ...[
                  _buildPasswordSection(),
                  const SizedBox(height: 20),
                ],

                // Evidence Upload Section
                _buildEvidenceSection(),

                const SizedBox(height: 30),

                // Privacy & Legal Notice
                _buildPrivacyNotice(),

                const SizedBox(height: 30),

                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset('assets/logos/logo_silent_signal.png', height: 80, width: 80),
        const SizedBox(height: 15),
        Text(
          'Evidence Upload',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Add photos, videos, or documents (Optional)',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set Report Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Create a password to track your anonymous report',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          InputTextField(
            controller: widget.passwordController,
            hintText: 'Enter a secure password',
            obscureText: true,
            labelText: 'Password *',
          ),
          if (passwordError != null && showValidationErrors)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                passwordError!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEvidenceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt,
                color: Colors.blue[600],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Evidence & Attachments',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Upload photos, videos, or documents to support your report',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Upload Area
          if (widget.selectedFiles.isEmpty) ...[
            _buildUploadArea(),
          ] else ...[
            _buildFileList(),
            const SizedBox(height: 20),
            _buildAddMoreButton(),
          ],

          const SizedBox(height: 15),

          // File limitations info
          _buildFileLimitations(),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue[300]!,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue[50],
      ),
      child: Column(
        children: [
          Icon(
            Icons.cloud_upload,
            size: 48,
            color: Colors.blue[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Drag & Drop or Click to Upload',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Photos, videos, documents',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUploadButton(Icons.camera_alt, 'Camera', () => widget.onCamera()),
              const SizedBox(width: 20),
              _buildUploadButton(Icons.photo_library, 'Gallery', () => widget.onGallery()),
              const SizedBox(width: 20),
              _buildUploadButton(Icons.attach_file, 'Files', () => widget.onPickFile()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue[600], size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Uploaded Files (${widget.selectedFiles.length}/5)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 15),
        ...widget.selectedFiles.asMap().entries.map((entry) {
          int index = entry.key;
          var file = entry.value;
          return _buildFileItem(file, index);
        }).toList(),
      ],
    );
  }

  Widget _buildFileItem(dynamic file, int index) {
    String fileName = file.path.split('/').last;
    String displayName = fileName.length > 30
        ? "${fileName.substring(0, 20)}...${fileName.substring(fileName.length - 8)}"
        : fileName;

    bool isImage = fileName.toLowerCase().endsWith('.jpg') ||
        fileName.toLowerCase().endsWith('.png') ||
        fileName.toLowerCase().endsWith('.jpeg');

    bool isVideo = fileName.toLowerCase().endsWith('.mp4') ||
        fileName.toLowerCase().endsWith('.mov') ||
        fileName.toLowerCase().endsWith('.avi');

    IconData fileIcon = isImage 
        ? Icons.image 
        : isVideo 
            ? Icons.videocam 
            : Icons.insert_drive_file;

    Color fileColor = isImage 
        ? Colors.green 
        : isVideo 
            ? Colors.purple 
            : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // File preview or icon
          if (isImage) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                file,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, color: Colors.grey[600]),
                  );
                },
              ),
            ),
          ] else ...[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: fileColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(fileIcon, color: fileColor, size: 24),
            ),
          ],
          
          const SizedBox(width: 12),
          
          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getFileSize(file),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Delete button
          IconButton(
            onPressed: () => _removeFile(index),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: widget.selectedFiles.length < 5 ? widget.onPickFile : null,
        icon: const Icon(Icons.add),
        label: Text(
          widget.selectedFiles.length < 5 
              ? 'Add More Files' 
              : 'Maximum 5 files reached',
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.blue[300]!),
        ),
      ),
    );
  }

  Widget _buildFileLimitations() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File Requirements:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[800],
                  ),
                ),
                Text(
                  '• Maximum 5 files • Each file ≤ 10MB\n• Supported: JPG, PNG, MP4, PDF, DOC',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.amber[700],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Privacy & Security',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'All files are encrypted and stored securely. Your identity remains anonymous. Only authorized personnel can access your evidence.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Previous Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onPrevious,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: BorderSide(color: Colors.grey[400]!),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Submit Button
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: widget.isSubmitting ? null : _validateAndSubmit,
            icon: Icon(
              widget.isSubmitting ? Icons.hourglass_empty : Icons.send,
              color: Colors.white,
            ),
            label: Text(
              widget.isSubmitting ? 'Submitting...' : 'Submit Report',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isSubmitting ? Colors.grey : Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getFileSize(File file) {
    try {
      int bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (e) {
      return 'Unknown size';
    }
  }

  void _removeFile(int index) {
    setState(() {
      widget.selectedFiles.removeAt(index);
    });
  }

  void _validateAndSubmit() {
    FocusScope.of(context).unfocus();
    
    // Only validate password if password field is shown
    if (widget.showPasswordField && widget.passwordController != null) {
      setState(() {
        showValidationErrors = true;

        // Validate password
        if (widget.passwordController!.text.isEmpty) {
          passwordError = 'Password is required';
        } else if (widget.passwordController!.text.length < 6) {
          passwordError = 'Password must be at least 6 characters long';
        } else {
          passwordError = null;
        }
      });

      // If password validation fails, don't proceed
      if (passwordError != null) {
        return;
      }
    }

    // If validation passes or no password field, proceed with submit
    widget.onSubmit();
  }
}