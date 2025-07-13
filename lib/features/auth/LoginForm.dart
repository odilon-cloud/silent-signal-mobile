import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:silentsignal/providers/user_provider.dart';
import 'package:silentsignal/providers/token_provider.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/features/auth/SignupForm.dart';
import 'package:silentsignal/common/validators/form_validator.dart';
import 'package:silentsignal/services/api_service.dart';

class Loginform extends StatefulWidget {
  const Loginform({super.key});

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Error message states
  String? emailError;
  String? passwordError;
  String? loginError;
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
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const Scaffold(
                          body: BaseLayout(),
                        );
                      }),
                    );
                  },
                  icon: const Icon(
                    Icons.info,
                    size: 30,
                  ),
                  label: Text(
                    'Continue Anonymously',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                if (loginError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      loginError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                      controller: passwordController,
                      hintText: 'password',
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
                SampleButton(
                  onTap: _validateAndSubmit,
                  buttonText: 'Submit',
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const Scaffold(
                              body: Signupform(),
                            );
                          }),
                        );
                      },
                      child: const Text(
                        'Sign up',
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
    FocusScope.of(context).unfocus();
    setState(() {
      showValidationErrors = true;

      // Validate email
      emailError = FormValidator.validateEmail(emailController.text);

      // Validate password
      if (passwordController.text.isEmpty) {
        passwordError = 'Password is required';
      } else {
        passwordError = null;
      }
    });

    // If all validations pass, proceed with form submission
    if (emailError == null && passwordError == null) {
      // Proceed with login
      _submitForm();
    }
  }

  void _submitForm() async {

    //clear any previous error messages
    setState((){
      loginError = null;
    });

    final apiService = ApiService(
        baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3011');
    String deviceType = 'Mobile';

    print("Sending to Backend: ");
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    print("DeviceType: $deviceType");
    final response = await apiService.post(
      endpoint: '/users/login',
      data: {
        'email': emailController.text,
        'password': passwordController.text,
        'deviceType': deviceType
      },
    );

    //Below , debugging message from the server was added
    print('Response from server:');
    print('Full response: $response');
    print('Response type: ${response.runtimeType}');


    //when the server returned nothing
    if(response==null){
      print('Nothing was returned by the server');
      setState((){
        loginError = 'Server is bugging. Try again later.';
      });
      return;
    }
      
      //Print fields found in the response
      print('Response fields: ${response.keys}');

      //Check if some specific fields exist
      print('Has token field: ${response.containsKey('token')}');
      print('Has user field: ${response.containsKey('userData')}');

      //Check what the backend actually returned
      if(response.containsKey('token')){
        print('Token value: ${response['token']}');
      }
      if(response.containsKey('userData')){
        print('User value:${response['userData']}');
      }
      //Check whether login was successful
    if (response != null &&
        response['token'] != null &&
        response['userData'] != null) {
          print('SUCCESS: Both token and user found in response');

          try{
            //save the data to phone storage

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', response['token']);
            await prefs.setString('user_info', jsonEncode(response['user']));
            print('Success: Data saved to phone storafge');
          
          //Update app state with user info
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          final tokenProvider = Provider.of<TokenProvider>(context, listen:false);

          userProvider.setUser(response['userData']);
          tokenProvider.setToken(response['token']);

          print('App state updated with user info');

      //Navigate to BaseLayout, replacing the current route
      print('success: About to navigate to BaseLayout');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BaseLayout(),
        ),
      );
      print('SUCCESS: Navigation completed');
    }catch(e){
      print('ERROR: failed to save data or navigate: $e');
      setState((){
        loginError = 'Login successful but failed to save data. Please try again.';
      });
    }
  }else{
    //Handle token or user not found
    print('Token or user missing from response');
    setState((){
      loginError = 'Login failed. Ensure you have valid credentials.';
    });
  }
  }
  

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
