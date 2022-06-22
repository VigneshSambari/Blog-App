// ignore_for_file: prefer_const_constructors
import 'package:blogapp/pages/signinpage.dart';
import 'package:blogapp/pages/signuppage.dart';

import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController animcontroller1;
  late Animation<Offset> animation1;
  late AnimationController animcontroller2;
  late Animation<Offset> animation2;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    //animation1
    animcontroller1 =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    animation1 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: animcontroller1, curve: Curves.easeOut),
    );
    animcontroller1.forward();
    //animation2
    animcontroller2 = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    animation2 = Tween<Offset>(
      begin: Offset(0.0, 8.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: animcontroller2, curve: Curves.elasticInOut),
    );
    animcontroller2.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animcontroller1.dispose();
    animcontroller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          // ignore: prefer_const_literals_to_create_immutables
          colors: [Colors.white, Colors.green],
          begin: const FractionalOffset(0.0, 1.0),
          end: const FractionalOffset(0.0, 1.0),
          stops: const [0.0, 1.0],
          tileMode: TileMode.repeated,
        )),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SlideTransition(
                position: animation1,
                child: Text(
                  "BlogApp",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 6),
              SlideTransition(
                position: animation1,
                child: Text(
                  "Great Stories for great people",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 20),
              boxContainer("assets/google.png", "SignUp with Google", null),
              SizedBox(height: 20),
              boxContainer(
                  "assets/facebook1.png", "SignUp with Facebook", null),
              SizedBox(height: 20),
              boxContainer(
                  "assets/email2.png", "SignUp with Email", onEmailClick),
              SizedBox(height: 20),
              SlideTransition(
                position: animation2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignInPage()));
                      },
                      child: Text("Signin",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onFBlogin() async {}

  onEmailClick() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  Widget boxContainer(String path, String name, onClick) {
    // ignore: sized_box_for_whitespace
    return SlideTransition(
      position: animation2,
      // ignore: sized_box_for_whitespace
      child: InkWell(
        onTap: onClick,
        // ignore: sized_box_for_whitespace
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 80,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(path, width: 25, height: 25),
                    SizedBox(width: 20),
                    Text(name,
                        style: TextStyle(fontSize: 16, color: Colors.black87)),
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
