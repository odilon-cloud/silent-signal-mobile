import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/password_field.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/features/auth/LoginForm.dart';
import 'package:silentsignal/common/validators/form_validator.dart';
import 'package:silentsignal/services/api_service.dart';

class Signupform extends StatefulWidget {
  const Signupform({super.key});

  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Error message states
  String? emailError;
  String? nameError;
  String? phoneNumberError;
  String? passwordError;
  String? confirmPasswordError;
  bool showValidationErrors = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Image.asset(
                  'assets/logos/logo_silent_signal.png',
                  height: 100,
                  width: 100,
                ),

                const SizedBox(height: 40),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTextField(
                      controller: firstNameController, 
                      hintText: "first name", 
                      obscureText: false,
                      labelText: 'First Name',
                    ),
                    if (nameError != null && showValidationErrors)
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 5),
                        child: Text(
                          nameError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 25),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTextField(
                      controller: lastNameController, 
                      hintText: "last name", 
                      obscureText: false,
                      labelText: 'Last Name',
                    ),
                    if (nameError != null && showValidationErrors)
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 5),
                        child: Text(
                          nameError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 25),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTextField(
                      controller: emailController, 
                      hintText: "youremail@gmail.com", 
                      obscureText: false,
                      labelText: 'Email *',
                    ),
                    if (emailError != null && showValidationErrors)
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 5),
                        child: Text(
                          emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 25),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTextField(
                      controller: phoneNumberController,
                      hintText: "+2507.............", 
                      obscureText: false,
                      labelText: 'Phone Number',
                    ),
                    if (phoneNumberError != null && showValidationErrors)
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 5),
                        child: Text(
                          phoneNumberError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputPasswordField(
                      obscureText: true,
                      labelText: 'Password',
                      controller: passwordController,
                      hintText: 'password',
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
                  ]
                ),
                const SizedBox(height: 25),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputPasswordField(
                      controller: confirmPasswordController, 
                      hintText: 'password', 
                      obscureText: true,
                      labelText: 'Confirm password',
                    ),
                    if (confirmPasswordError != null && showValidationErrors)
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 5),
                        child: Text(
                          confirmPasswordError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 25),

                SampleButton(
                  onTap: _validateAndSubmit,
                  buttonText: 'Submit',
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.7
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Are you a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Loginform()),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    setState(() {
      showValidationErrors = true;

      // Validate email
      emailError = FormValidator.validateEmail(emailController.text);

      // Validate name (optional field)
      if (firstNameController.text.isNotEmpty && firstNameController.text.length < 2) {
        nameError = 'Name must be at least 2 characters';
      } else {
        nameError = null;
      }
      // Validate name (optional field)
      if (lastNameController.text.isNotEmpty && lastNameController.text.length < 2) {
        nameError = 'Name must be at least 2 characters';
      } else {
        nameError = null;
      }

      phoneNumberError = FormValidator.validatePhoneNumber(phoneNumberController.text);

      // Validate password
      if (passwordController.text.isEmpty) {
        passwordError = 'Password is required';
      } else if (passwordController.text.length < 6) {
        passwordError = 'Password must be at least 6 characters';
      } else {
        passwordError = null;
      }

      // Validate confirm password
      if (confirmPasswordController.text.isEmpty) {
        confirmPasswordError = 'Please confirm your password';
      } else if (confirmPasswordController.text != passwordController.text) {
        confirmPasswordError = 'Passwords do not match';
      } else {
        confirmPasswordError = null;
      }
    });

    // If all validations pass, proceed with form submission
    if (emailError == null && 
        nameError == null && 
        passwordError == null && 
        phoneNumberError == null &&
        confirmPasswordError == null) {
      // Proceed with signup
      _submitForm();
    }
  }

  void _submitForm() async {
    // Add your signup logic here

     final apiService = ApiService(baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');

    final response = await apiService.post(
      endpoint: '/users',  
      data: {
        'firstName':firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'userPassword': passwordController.text,
        'role':'user',
        'phone_number': phoneNumberController.text,
      },
    );

    print(response);
    
    if (response != null && response['status'] == 'success'  || response['id'] != null) {
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
               Text('Account Created successfully!'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Loginform()),
                );
              },
            ),
          ],
        );
      },
    );
  
    } else {
      // Handle Signup failure with custom message
     print('Sign up Failed: ${response?['message'] ?? 'Unknown error'}');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response?['message'] ?? 'Unknown error occurred during sign up',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}