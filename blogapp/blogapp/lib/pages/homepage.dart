// ignore_for_file: prefer_const_constructors

import 'package:blogapp/blogs/addblog.dart';
import 'package:blogapp/pages/welcomepage.dart';
import 'package:blogapp/screens/homescreen.dart';
import 'package:blogapp/screens/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../networkhandler.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentscreen = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> screens = ["Home Page", "Profile Page"];
  final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  Widget screen = Center(child: CircularProgressIndicator());
  String username = "@username";

  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Colors.black,
    ),
  );

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    var response = await networkHandler.get("/profile/checkProfile");
    setState(() {
      username = response['username'];
    });
    if (response['status'] == true) {
      setState(() {
        profilePhoto = CircleAvatar(
          radius: 50,
          backgroundImage: NetworkHandler().getImage(response['username']),
        );
      });
    } else {
      setState(() {
        profilePhoto = Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.black,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              profilePhoto,
              SizedBox(
                height: 10,
              ),
              Text("@$username")
            ],
          )),
          ListTile(
            title: Text("All Posts"),
            trailing: Icon(Icons.launch),
          ),
          ListTile(
            title: Text("New Blog"),
            trailing: Icon(Icons.add),
          ),
          ListTile(
            title: Text("Settings"),
            trailing: Icon(Icons.settings),
          ),
          ListTile(
            title: Text("Feedback"),
            trailing: Icon(Icons.feedback),
          ),
          ListTile(
            title: Text("Logout"),
            trailing: Icon(Icons.logout),
            onTap: logOut,
          )
        ],
      )),
      appBar: AppBar(
        title: Text(screens[currentscreen]),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Text(
          "+",
          style: TextStyle(fontSize: 35),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        // ignore: sized_box_for_whitespace
        child: Container(
          height: 60,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                IconButton(
                  color: currentscreen == 0 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentscreen = 0;
                    });
                  },
                  icon: Icon(Icons.home),
                  iconSize: 30,
                  splashColor: Colors.yellow,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentscreen = 1;
                    });
                  },
                  color: currentscreen == 1 ? Colors.white : Colors.white54,
                  icon: Icon(Icons.person),
                  iconSize: 30,
                  splashColor: Colors.yellow,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentscreen],
    );
  }

  void logOut() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false);
  }
}
