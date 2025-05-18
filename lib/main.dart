import 'package:auth_modul/screens/home.dart';
import 'package:auth_modul/screens/login.dart';
import 'package:auth_modul/screens/register.dart';
import 'package:auth_modul/screens/second_screen.dart';
import 'package:auth_modul/screens/notification_test_screen.dart';
import 'package:auth_modul/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth + Notification Module',
      navigatorKey: navigatorKey,
      initialRoute: 'login', routes: {
        'home': (context) => const HomePage(),
        'login': (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'notification': (context) => const NotificationTestScreen(),
        'second': (context) => const SecondScreen(),
      },
    );
  }
}