import 'package:fluttify/screens/details_screen.dart';
import 'package:fluttify/screens/home_screen.dart';
import 'package:fluttify/screens/login_screen.dart';

var appRoutes = {
  '/': (context) => const LoginScreen(),
  '/home': (context) => const HomeScreen(),
  '/details': (context) => const DetailsScreen(),
};
