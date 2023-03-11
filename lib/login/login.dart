import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/services/auth.dart';
import 'package:fluttify/home/home.dart';
import 'package:fluttify/shared/shared.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController = TextEditingController();
  final TextEditingController _repeatedPasswordFieldController = TextEditingController();
  bool _isLoginPage = true;

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
              _isLoginPage ? "Sign in to fluttify" : "Create Account",
              style: const TextStyle(color: Colors.white, fontSize: 32),
            ),
            SizedBox(height: screenHeight / 15),
            CustomTextFormField(
                controller: _emailFieldController, labelText: "Email", hintText: "youremail@email.com", obscure: false),
            SizedBox(height: screenHeight / 100),
            CustomTextFormField(
                controller: _passwordFieldController, labelText: "Password", hintText: "password", obscure: true),
            SizedBox(height: screenHeight / 100),
            Visibility(
              visible: !_isLoginPage,
              child: CustomTextFormField(
                  controller: _repeatedPasswordFieldController,
                  labelText: "Repeat password",
                  hintText: "password",
                  obscure: true),
            ),
            SizedBox(height: screenHeight / 15),
            ElevatedButton(
              onPressed: () async {
                bool shouldRedirect = _isLoginPage
                    ? await signIn(_emailFieldController.text, _passwordFieldController.text)
                    : await signUp(
                        _emailFieldController.text,
                        _passwordFieldController.text,
                        _repeatedPasswordFieldController.text,
                      );
                if (shouldRedirect) {
                  Fluttertoast.showToast(
                    msg: _isLoginPage ? "Logged in" : "Account created",
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
                _isLoginPage ? "Sign in" : "Register and login",
                style: const TextStyle(color: Colors.indigo),
              ),
            ),
            TextButton(
              onPressed: () => setState(() {
                _isLoginPage = !_isLoginPage;
                _emailFieldController.clear();
                _passwordFieldController.clear();
                _repeatedPasswordFieldController.clear();
                FocusScope.of(context).unfocus();
              }),
              child: Text(
                _isLoginPage ? "go to registration page" : "go back to the login page",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
