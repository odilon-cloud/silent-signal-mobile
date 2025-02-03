import 'package:flutter/material.dart';
import 'package:silentsignal/common/components/button.dart';
import 'package:silentsignal/common/components/textfield.dart';
import 'package:silentsignal/features/auth/LoginForm.dart';

class Signupform extends StatelessWidget {
  Signupform({super.key});

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              InputTextField(
                controller: emailController, 
                hintText: "youremail@gmail.com", 
                obscureText: false,
                labelText: 'Email *',
              ),

              const SizedBox(height: 25),

              InputTextField(
                controller: nameController, 
                hintText: "name", 
                obscureText: false,
                labelText: 'Full name',
              ),

              const SizedBox(height: 25),

              InputTextField(
                controller: passwordController,
                hintText: '**********',
                obscureText: true,
                labelText: 'Password',
              ),
              
              const SizedBox(height: 25),
              InputTextField(
                controller: confirmPasswordController, 
                hintText: "**********", 
                obscureText: false,
                labelText: 'Retype password',
              ),

              const SizedBox(height: 25),

               SampleButton(
                onTap:  (){}, 
                buttonText: 'Submit',
                height: 40,
                width:  MediaQuery.of(context).size.width * 0.7
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
                        MaterialPageRoute(builder: (context) {
                          return Scaffold( 
                            body: Loginform(), 
                          );
                        }),
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
        )),
    );
  }
}