import 'package:flutter/material.dart';
import 'package:video_video/controller/auth_controller.dart';
import '../../widgets/text_input.dart';
import 'signup_screen.dart';   // 👈 ADD THIS

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController =
  TextEditingController();
  final TextEditingController _passwordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Login",
              style: TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 20),

            TextInputField(
              controller: _emailController,
              myIcon: Icons.email,
              myLabelText: "Email",
            ),

            const SizedBox(height: 20),

            TextInputField(
              controller: _passwordController,
              myIcon: Icons.lock,
              myLabelText: "Password",
              toHide: true,
            ),

            const SizedBox(height: 30),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  AuthController.instance.login(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                child: const Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Text("Login"),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 👇 SIGNUP LINK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
