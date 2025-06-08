import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/textfield.dart';

class FileUploadPage extends StatefulWidget {
  final List<dynamic> selectedFiles;
  final VoidCallback onPickFile;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;
  final PageController pageController;
  final bool showPasswordField;
  final TextEditingController? passwordController;

  const FileUploadPage({
    Key? key,
    required this.selectedFiles,
    required this.onPickFile,
    required this.onPrevious,
    required this.onSubmit,
    required this.pageController,
    this.showPasswordField = false,
    this.passwordController,
  }) : super(key: key);

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  String? passwordError;
  bool showValidationErrors = false;

  @override
  Widget build(BuildContext context) {
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

              const SizedBox(height: 30),

              // Password field for anonymous users
              if (widget.showPasswordField) ...[
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
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Password for Anonymous Report',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Create a password to track your report status later',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 15),
                      InputTextField(
                        controller: widget.passwordController,
                        hintText: 'password',
                        obscureText: true,
                        labelText: 'Password *',
                      ),
                      if (passwordError != null && showValidationErrors)
                        Padding(
                          padding: const EdgeInsets.only(left: 25, top: 5),
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
                ),
                const SizedBox(height: 20),
              ],

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
                      offset: const Offset(0, 2),
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
                    if (widget.selectedFiles.isNotEmpty)
                      Column(
                        children: widget.selectedFiles.map((file) {
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
                          onPressed: widget.onPickFile,
                        ),
                        const SizedBox(width: 20), // Space between icons
                        IconButton(
                          icon: const Icon(Icons.attachment, color: Colors.blue, size: 40),
                          onPressed: widget.onPickFile,
                        ),
                      ],
                    ),
                  ],
                ),
              ), 

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔙 Previous Button
                  ElevatedButton(
                    onPressed: widget.onPrevious,
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
                    onPressed: _validateAndSubmit,
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