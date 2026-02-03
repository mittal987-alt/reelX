import 'package:flutter/material.dart';
import 'package:video_video/controller/auth_controller.dart';
import '../../widgets/text_input.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthController authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Signup", style: TextStyle(fontSize: 24)),

              const SizedBox(height: 20),

               InkWell(
                onTap: authController.pickImage,
                child: CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.deepPurple,
                  backgroundImage: authController.proimg.value != null
                      ? FileImage(authController.proimg.value!)
                      : null,
                  child: authController.proimg.value == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              TextInputField(
                controller: _usernameController,
                myIcon: Icons.person,
                myLabelText: "Username",
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
              const SizedBox(height: 20),

              TextInputField(
                controller: _confirmPasswordController,
                myIcon: Icons.lock,
                myLabelText: "confirmPassword",
                toHide: true,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  authController.signup(
                    _usernameController.text.trim(),
                    _emailController.text.trim(),
                    _passwordController.text.trim(),

                                    );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Text("Signup"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
