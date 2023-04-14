import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttify/services/auth.dart';
import 'package:fluttify/shared/shared.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController = TextEditingController();
  final TextEditingController _repeatedPasswordFieldController = TextEditingController();
  bool _isConnected = false;
  late StreamSubscription<InternetConnectionStatus> _listener;
  bool _isLoginPage = true;
  int _key = 1;

  @override
  initState() {
    super.initState();
    InternetConnectionChecker()
        .hasConnection
        .then((value) => _isConnected = value);
    _listener = InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) => setState(() {
            _isConnected = status == InternetConnectionStatus.connected;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // outer container to cover white animation background
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Theme.of(context).colorScheme.primary,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) => FadeThroughTransition(
            animation: animation,
            secondaryAnimation: Tween<double>(begin: 0, end: 0).animate(animation),
            child: child,
          ),
          // main container
          child: Container(
            key: ValueKey<int>(_key),
            width: screenWidth,
            height: screenHeight,
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: _isLoginPage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.shopping_cart,
                            size: 75,
                            color: _isConnected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    SizedBox(height: screenHeight / 50),
                    Text(
                      _isLoginPage ? "Sign in to fluttify" : "Create Account",
                      style: const TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    SizedBox(height: screenHeight / 15),
                    LoginTextFormField(
                        controller: _emailFieldController, labelText: "Email", hintText: "youremail@email.com", obscure: false),
                    SizedBox(height: screenHeight / 100),
                    LoginTextFormField(controller: _passwordFieldController, labelText: "Password", hintText: "password", obscure: true),
                    SizedBox(height: screenHeight / 100),
                    Visibility(
                      visible: !_isLoginPage,
                      child: LoginTextFormField(
                          controller: _repeatedPasswordFieldController, labelText: "Repeat password", hintText: "password", obscure: true),
                    ),
                    SizedBox(height: screenHeight / 15),
                    ElevatedButton(
                      onPressed: _isConnected
                          ? () async {
                              bool shouldRedirect = _isLoginPage
                                  ? await signIn(_emailFieldController.text,
                                      _passwordFieldController.text)
                                  : await signUp(
                                      _emailFieldController.text,
                                      _passwordFieldController.text,
                                      _repeatedPasswordFieldController.text,
                                    );
                              if (shouldRedirect) {
                                _listener.cancel();
                                Fluttertoast.showToast(
                                  msg: _isLoginPage
                                      ? "Logged in"
                                      : "Account created",
                                );
                                if (!mounted) return;
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            }
                          : () => Fluttertoast.showToast(
                              msg: 'No internet connection'),
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
                        _key = _isLoginPage ? 1 : 2;
                      }),
                      child: Text(
                        _isLoginPage ? "go to registration page" : "go back to the login page",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
