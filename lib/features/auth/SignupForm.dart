import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/features/auth/LoginForm.dart';
import 'package:silentsignal/common/validators/form_validator.dart';

class Signupform extends StatefulWidget {
  const Signupform({super.key});

  @override
  State<Signupform> createState() => _SignupformState();
}

class _SignupformState extends State<Signupform> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Error message states
  String? emailError;
  String? nameError;
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
                      controller: nameController, 
                      hintText: "name", 
                      obscureText: false,
                      labelText: 'Full name',
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
                      controller: passwordController,
                      hintText: '............',
                      obscureText: true,
                      labelText: 'Password',
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
                
                const SizedBox(height: 25),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTextField(
                      controller: confirmPasswordController, 
                      hintText: '............', 
                      obscureText: true,
                      labelText: 'Retype password',
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
                          MaterialPageRoute(builder: (context) => Loginform()),
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
      if (nameController.text.isNotEmpty && nameController.text.length < 2) {
        nameError = 'Name must be at least 2 characters';
      } else {
        nameError = null;
      }

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
        confirmPasswordError == null) {
      // Proceed with signup
      _submitForm();
    }
  }

  void _submitForm() {
    // Add your signup logic here
    print('Form submitted with:');
    print('Email: ${emailController.text}');
    print('Name: ${nameController.text}');
    print('Password: ${passwordController.text}');
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}