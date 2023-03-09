import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/net/auth.dart';
import 'package:fluttify/ui/home/home.dart';
import 'package:fluttify/ui/registration/registration.dart';
import 'package:fluttify/ui/shared/shared.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController = TextEditingController();

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
              "Sign in to fluttify",
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
            SizedBox(height: screenHeight / 15),
            CustomTextFormField(controller: _emailFieldController, labelText: "Email", hintText: "youremail@email.com", obscure: false),
            SizedBox(height: screenHeight / 100),
            CustomTextFormField(controller: _passwordFieldController, labelText: "Password", hintText: "password", obscure: true),
            SizedBox(height: screenHeight / 15),
            ElevatedButton(
              onPressed: () async {
                bool shouldRedirect = await signIn(_emailFieldController.text, _passwordFieldController.text);
                if (shouldRedirect) {
                  Fluttertoast.showToast(msg: "Logged in");
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "Sign in",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Registration(),
                  ),
                );
              },
              child: const Text(
                "go to registration page",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
