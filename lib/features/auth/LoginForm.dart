import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/base_layout.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/features/auth/SignupForm.dart';

class Loginform extends StatelessWidget {
  Loginform({super.key});
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // Add your button action here
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //backgroundColor: Colors.grey[200],
                //foregroundColor: Colors.grey[800],
                elevation: 1,
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

              InputTextField(
                controller: emailController, 
                hintText: "youremail@gmail.com", 
                obscureText: false,
                labelText: 'Email *',
              ),

              const SizedBox(height: 25),

              InputTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
                labelText: 'Password',
              ),
              
              const SizedBox(height: 25),

              SampleButton(
                onTap:  (){
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Scaffold( 
                            // appBar: AppBar(
                            //   title: Text('Signup'),
                            //   backgroundColor: Colors.black, 
                            // ),
                            body: BaseLayout(), 
                          );
  
                        }),
                  );
                }, 
                buttonText: 'Submit',
                height: 40,
                width:  MediaQuery.of(context).size.width * 0.7
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
                          return Scaffold( 
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
        )
      ),

    );
  }
}