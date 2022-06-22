// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:convert';
import 'package:blogapp/pages/homepage.dart';
import 'package:blogapp/pages/signinpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogapp/networkhandler.dart';
import 'package:blogapp/pages/signuppage.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
              "Forgot Password",
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
                Map<String, String> data = {
                  "password": passwordController.text,
                };
                var response = await networkHandler.patch(
                    "/user/update/$usernameController.text", data);
                if (response.statusCode == 200 || response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Password updated successfully")));
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignInPage()),
                      (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error updating password")));
                }
              },
              child: Container(
                height: 50,
                width: 200,
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
                          "Update Password",
                          style: TextStyle(
                            fontSize: 17,
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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Text(
                    "SignIn",
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
