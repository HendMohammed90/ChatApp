import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  bool _spinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo1',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  _email = value;
                },
                decoration: KTextFileDecoration.copyWith(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.amber,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  _password = value;
                },
                decoration: KTextFileDecoration.copyWith(
                  hintStyle: TextStyle(
                    color: Colors.amber,
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButtton(
                text: 'Log In',
                color: Colors.lightBlueAccent,
                function: () async {
                  //Go to registration screen.
                  // print(_email);
                  // print(_password);
                  setState(() {
                    _spinner = true;
                  });
                  try {
                    final logedUser = await _auth.signInWithEmailAndPassword(
                        email: _email, password: _password);
                    if (logedUser != null) {
                      Navigator.pushNamed(context, ChatScreen.route);
                    }
                  } catch (error) {
                    print(error);
                  }
                  setState(() {
                    _spinner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
