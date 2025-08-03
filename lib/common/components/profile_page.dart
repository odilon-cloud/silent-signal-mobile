// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:silentsignal/features/auth/LoginForm.dart';
// import 'package:silentsignal/providers/token_provider.dart';
// import 'package:silentsignal/providers/user_provider.dart'; // Make sure to add this import

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [  
//               const Text(
//                 'Settings',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14),
//               ),
//               const SizedBox(height: 40),          
//               Card(
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Icon(Icons.contacts),
//                       Text(
//                         'Personal info',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       Icon(Icons.arrow_forward_ios_outlined),
//                     ],
//                   ),
//                 ),
//               ),
//              const SizedBox(height: 20),
//               Card(
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Icon(Icons.contacts),
//                       Text(
//                         'Personal info',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       Icon(Icons.arrow_forward_ios_outlined),
//                     ],
//                   ),
//                 ),
//               ),    
              
//               const SizedBox(height: 20),

//               Card(
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Icon(Icons.contacts),
//                       Text(
//                         'Contact info',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       Icon(Icons.arrow_forward_ios_outlined),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Card(
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16.0),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Icon(Icons.contacts),
//                       Text(
//                         'Personal info',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       Icon(Icons.arrow_forward_ios_outlined),
//                     ],
//                   ),
//                 ),
//               ),
              
//               // Add spacing before logout section
//               const SizedBox(height: 40),
              
//               // Logout Card with red styling
//               Card(
//                 color: Colors.red.shade50,  // Light red background
//                 child: InkWell(
//                   onTap: () {
//                     // Use the simpler QuickAlert for logout confirmation
//                     QuickAlert.show(
//                       context: context,
//                       type: QuickAlertType.confirm,
//                       text: 'Do you want to logout',
//                       confirmBtnText: 'Yes',
//                       cancelBtnText: 'No',
//                       confirmBtnColor: Colors.green,
//                       onConfirmBtnTap: () async {
//                         // Get SharedPreferences instance
//                         SharedPreferences prefs = await SharedPreferences.getInstance();
                        
//                         // Clear token and user info
//                         await prefs.remove('auth_token');
//                         await prefs.remove('user_info');
                        
//                         // Clear providers
//                         Provider.of<UserProvider>(context, listen: false).clearUser();
//                         Provider.of<TokenProvider>(context, listen: false).clearToken();
                        
//                         // Close the dialog
//                         Navigator.pop(context);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const Loginform()),
//                         );
//                       },
//                     );
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Icon(Icons.logout, color: Colors.red),
//                         const Text(
//                           'Logout',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Icon(Icons.arrow_forward_ios_outlined, color: Colors.red.withOpacity(0.7)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:silentsignal/features/auth/LoginForm.dart';
import 'package:silentsignal/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      // Check if user provider has user data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      setState(() {
        isLoggedIn = (userProvider.user != null && userProvider.user!['id'] != null);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoggedIn = false;
        isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to logout',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () async {
        // Get SharedPreferences instance
        SharedPreferences prefs = await SharedPreferences.getInstance();
        
        // Clear user info
        await prefs.remove('user_info');
        
        // Clear providers
        Provider.of<UserProvider>(context, listen: false).clearUser();
        
        // Update login status
        setState(() {
          isLoggedIn = false;
        });
        
        // Close the dialog
        Navigator.pop(context);
        
        // Show success message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Logged out successfully',
          autoCloseDuration: const Duration(seconds: 2),
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    // Navigate to login page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Loginform()),
    );
    
    // Check login status again when returning from login page
    if (result == true || mounted) {
      _checkLoginStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [  
              const Text(
                'Settings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 40),          
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.person),
                      Text(
                        'Personal info',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                ),
              ),
             const SizedBox(height: 20),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings),
                      Text(
                        'Preferences',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                ),
              ),    
              
              const SizedBox(height: 20),

              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.contact_mail),
                      Text(
                        'Contact info',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.help_outline),
                      Text(
                        'Help & Support',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                ),
              ),
              
              // Add spacing before auth section
              const SizedBox(height: 40),
              
              // Dynamic Login/Logout Card
              if (isLoading)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else
                Card(
                  color: isLoggedIn ? Colors.red.shade50 : Colors.green.shade50,
                  child: InkWell(
                    onTap: isLoggedIn ? _handleLogout : _handleLogin,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            isLoggedIn ? Icons.logout : Icons.login,
                            color: isLoggedIn ? Colors.red : Colors.green,
                          ),
                          Text(
                            isLoggedIn ? 'Logout' : 'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: isLoggedIn ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: isLoggedIn 
                              ? Colors.red.withOpacity(0.7) 
                              : Colors.green.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}