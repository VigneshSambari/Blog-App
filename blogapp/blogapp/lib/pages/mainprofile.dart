// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blogapp/blogs/blogs.dart';
import 'package:blogapp/model/profileModel.dart';
import 'package:blogapp/networkhandler.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({Key? key}) : super(key: key);

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();
  ProfileModel profileModel = ProfileModel();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get("/profile/getData");
    setState(() {
      profileModel = ProfileModel.fromJson(response["data"]);
      circular = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                head(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Divider(
                    thickness: 0.8,
                  ),
                ),
                details("Name", profileModel.name),
                details("Profession", profileModel.profession),
                details("Date of Birth", profileModel.DOB),
                details("About", profileModel.about),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Divider(
                    thickness: 0.8,
                  ),
                ),
                Blogs(url: "/blogpost/getOwnBlog"),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
          ),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkHandler().getImage(profileModel.username),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.username,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text(profileModel.titleline),
        ],
      ),
    );
  }

  Widget details(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label :",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
