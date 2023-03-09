import 'package:flutter/material.dart';
import 'package:fluttify/ui/login/login.dart';
import 'package:fluttify/ui/shared/shared.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  final TextEditingController _repeatPasswordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(color: Colors.indigo),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
            SizedBox(height: screenHeight / 15),
            CustomTextFormField(controller: _emailField, labelText: "Email", hintText: "youremail@email.com"),
            SizedBox(height: screenHeight / 100),
            CustomTextFormField(controller: _passwordField, labelText: "Password", hintText: "youremail@password.com"),
            SizedBox(height: screenHeight / 100),
            CustomTextFormField(controller: _repeatPasswordField, labelText: "Repeat password", hintText: "password"),
            SizedBox(height: screenHeight / 15),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "Register and login",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
              child: const Text(
                "go back to the login page",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
