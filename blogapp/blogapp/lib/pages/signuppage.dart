// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:blogapp/pages/signinpage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:blogapp/networkhandler.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

// ignore: use_key_in_widget_constructors
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errortext = "";
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
              "SignUp with Email",
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
            emailTextField(),
            passwordTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                await checkUser();
                if (globalkey.currentState!.validate() && validate) {
                  Map<String, String> data = {
                    "username": usernameController.text,
                    "email": emailController.text,
                    "password": passwordController.text
                  };
                  var responseRegister =
                      await networkHandler.post("/user/register", data);
                  if (responseRegister.statusCode == 200 ||
                      responseRegister.statusCode == 201) {
                    Map<String, String> data = {
                      "username": usernameController.text,
                      "password": passwordController.text,
                    };
                    var response =
                        await networkHandler.post("/user/login", data);
                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      // ignore: avoid_print
                      print(output["token"]);
                      await storage.write(key: "token", value: output["token"]);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                      setState(() {
                        validate = true;
                        circular = false;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Network Error")));
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
                          "SignUp",
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Text(
                    "SignIn",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

  checkUser() async {
    if (usernameController.text.isEmpty) {
      setState(() {
        // circular = false;
        validate = false;
        errortext = "Username can't be empty";
      });
    } else {
      var response = await networkHandler
          .get("/user/checkusername/${usernameController.text}");
      if (response['Status'] == true) {
        setState(() {
          //circular = false;
          errortext = "Username already taken";
          validate = false;
          return;
        });
      } else {
        setState(() {
          validate = true;
          //circular = false;
        });
      }
    }
  }

  Widget usernameTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Column(
        children: [
          Text("Username", style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
                errorText:
                    validate == true || errortext == "" ? null : errortext,
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

  Widget emailTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Column(
        children: [
          Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) return "Email cannot be empty";
              if (!value.contains("@")) return "Email is invalid";
              return null;
            },
            decoration: InputDecoration(
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
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) return "Password cannot be empty";
              if (value.length < 8) {
                return "Password should have atleast 8 characters";
              }
              return null;
            },
            obscureText: vis,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        vis = !vis;
                      });
                    },
                    icon: Icon(vis ? Icons.visibility_off : Icons.visibility)),
                helperText: "Password should be atleast 8 characters",
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
