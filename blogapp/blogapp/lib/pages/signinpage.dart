// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:blogapp/pages/forgotpassword.dart';
import 'package:blogapp/pages/homepage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogapp/networkhandler.dart';
import 'package:blogapp/pages/signuppage.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final globalkey = GlobalKey<FormState>();
  String errorText = "";
  bool validate = false;
  bool circular = false;
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.white, Colors.green.shade400],
        begin: const FractionalOffset(0.0, 1.0),
        end: const FractionalOffset(0.0, 1.0),
        stops: const [0.0, 1.0],
        tileMode: TileMode.repeated,
      )),
      child: Form(
        key: globalkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SignIn with Email",
              style: TextStyle(
                fontSize: 30,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            usernameTextField(),
            passwordTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (globalkey.currentState!.validate()) {
                  Map<String, String> data = {
                    "username": usernameController.text,
                    "password": passwordController.text,
                  };
                  var response = await networkHandler.post("/user/login", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    Map<String, dynamic> output = json.decode(response.body);
                    // ignore: avoid_print
                    print(output['token']);
                    await storage.write(key: "token", value: output['token']);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false);
                    setState(() {
                      validate = true;
                      circular = false;
                    });
                  } else {
                    String output = json.decode(response.body);
                    setState(() {
                      errorText = output;
                      validate = false;
                      circular = false;
                    });
                  }
                }
                setState(() {
                  circular = false;
                });
              },
              child: Container(
                height: 50,
                width: 180,
                decoration: BoxDecoration(
                  color: Color(0xff00A86B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: circular
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "SignIn",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    "New User?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[900]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  Widget usernameTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Column(
        children: [
          Text("Username", style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            validator: (value) {
              if (usernameController.text.isEmpty) {
                return "Username cannot be empty";
              }
              return null;
            },
            controller: usernameController,
            decoration: InputDecoration(
                errorText:
                    validate ? null : (errorText == "" ? null : errorText),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  width: 2,
                  color: Colors.black54,
                ))),
          )
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Column(
        children: [
          Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            validator: (value) {
              if (passwordController.text.isEmpty) {
                return "Password cannot be empty";
              }
              return null;
            },
            controller: passwordController,
            obscureText: vis,
            decoration: InputDecoration(
                errorText:
                    validate ? null : (errorText == "" ? null : errorText),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        vis = !vis;
                      });
                    },
                    icon: Icon(vis ? Icons.visibility_off : Icons.visibility)),
                helperStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.green[900],
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  width: 2,
                  color: Colors.black54,
                ))),
          )
        ],
      ),
    );
  }
}
