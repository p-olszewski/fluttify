import 'package:flutter/material.dart';
import 'package:fluttify/screens/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  final TextEditingController _repeatPasswordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var widgetWidth = screenWidth / 1.3;

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
            SizedBox(
              width: widgetWidth,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _emailField,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: "Email",
                  hintStyle: TextStyle(color: Color.fromARGB(255, 144, 161, 252)),
                  hintText: "youremail@email.com",
                ),
              ),
            ),
            SizedBox(height: screenHeight / 100),
            SizedBox(
              width: widgetWidth,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _passwordField,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: "Password",
                  hintStyle: TextStyle(color: Color.fromARGB(255, 144, 161, 252)),
                  hintText: "password",
                ),
              ),
            ),
            SizedBox(height: screenHeight / 100),
            SizedBox(
              width: widgetWidth,
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _repeatPasswordField,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: "Repeat password",
                  hintStyle: TextStyle(color: Color.fromARGB(255, 144, 161, 252)),
                  hintText: "password",
                ),
              ),
            ),
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
                    builder: (context) => const LoginScreen(),
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
