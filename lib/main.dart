import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() => runApp(FlashChat());
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //////// Happy
  await Firebase.initializeApp(); //////// Happy
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //       // bodyText1: TextStyle(color: Colors.black54),
      //       ),
      // ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.route: (context) => RegistrationScreen(),
        LoginScreen.route: (context) => LoginScreen(),
        ChatScreen.route: (context) => ChatScreen(),
      },
    );
  }
}

// tech@thesparksfoundation.sg
// grip@thesparksfoundation.sg
