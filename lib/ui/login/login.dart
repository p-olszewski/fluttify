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
  final TextEditingController _repeatedPasswordFieldController = TextEditingController();
  bool isLoginView = true;

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
            Text(
              isLoginView ? "Sign in to fluttify" : "Create Account",
              style: const TextStyle(color: Colors.white, fontSize: 32),
            ),
            SizedBox(height: screenHeight / 15),
            CustomTextFormField(controller: _emailFieldController, labelText: "Email", hintText: "youremail@email.com", obscure: false),
            SizedBox(height: screenHeight / 100),
            CustomTextFormField(controller: _passwordFieldController, labelText: "Password", hintText: "password", obscure: true),
            SizedBox(height: screenHeight / 100),
            Visibility(
              visible: !isLoginView,
              child: CustomTextFormField(
                  controller: _repeatedPasswordFieldController, labelText: "Repeat password", hintText: "password", obscure: true),
            ),
            SizedBox(height: screenHeight / 15),
            ElevatedButton(
              onPressed: () async {
                bool shouldRedirect = isLoginView
                    ? await signIn(_emailFieldController.text, _passwordFieldController.text)
                    : await signUp(
                        _emailFieldController.text,
                        _passwordFieldController.text,
                        _repeatedPasswordFieldController.text,
                      );
                if (shouldRedirect) {
                  Fluttertoast.showToast(
                    msg: isLoginView ? "Logged in" : "Account created",
                  );
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
              child: Text(
                isLoginView ? "Sign in" : "Register and login",
                style: const TextStyle(color: Colors.indigo),
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoginView = !isLoginView;
                });
              },
              child: Text(
                isLoginView ? "go to registration page" : "go back to the login page",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
