// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:blogapp/networkhandler.dart';
import 'package:blogapp/pages/mainprofile.dart';
import 'package:blogapp/profile/createprofile.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  Widget screen = Center(child: CircularProgressIndicator());

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    if (response['status'] == true) {
      setState(() {
        screen = MainProfile();
      });
    } else {
      setState(() {
        screen = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen,
    );
  }

  Widget showProfile() {
    return Center(child: Text("Profile available"));
  }

  Widget progressBar() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget button() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Click to add Profile",
            style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateProfile()));
            },
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.teal,
              ),
              child: Center(
                child: Text("Add Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
