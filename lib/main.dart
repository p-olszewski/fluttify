import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttify/details/details.dart';
import 'package:fluttify/home/home.dart';
import 'package:fluttify/login/login.dart';
import 'package:fluttify/providers/shopping_list_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ShoppingListProvider>(create: (_) => ShoppingListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fluttify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
        ).copyWith(
          secondary: Colors.red,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/home': (context) => const Home(),
        '/details': (context) => const Details(),
      },
    );
  }
}
