import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/rounded_button.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  ///////////
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this, ////////////
      duration: Duration(seconds: 3),
      // upperBound: 200.0,
      // lowerBound: 0.0,
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = ColorTween(begin: Colors.lightBlueAccent, end: Colors.white)
        .animate(controller);
    controller.forward(); // make animation work pushing it from num to another

    controller.addListener(() {
      ///// to check the controller
      setState(() {});
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo1',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 90,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: [
                    'Flash Chat',
                  ],
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber,
                  ),
                  speed: Duration(milliseconds: 100),
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButtton(
              text: 'Log In',
              color: Colors.lightBlueAccent,
              function: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.route);
              },
            ),
            RoundedButtton(
              text: 'Register',
              color: Colors.blueAccent,
              function: () {
                //Go to registration screen.
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// '''Log In'''
// Colors.lightBlueAccent
//  () {
//  //Go to login screen.
//  Navigator.pushNamed(context, LoginScreen.route);
//  }
