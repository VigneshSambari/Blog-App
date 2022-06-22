// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, avoid_init_to_null, unused_local_variable

import 'dart:io';
import 'package:blogapp/networkhandler.dart';
import 'package:blogapp/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final globalKey = GlobalKey<FormState>();
  PickedFile? imageFile = null;
  final ImagePicker picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  final networkHandler = NetworkHandler();
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: globalKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 10,
            ),
            DOBTextField(),
            SizedBox(
              height: 10,
            ),
            professionTextField(),
            SizedBox(
              height: 10,
            ),
            titleTextField(),
            SizedBox(
              height: 10,
            ),
            aboutTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  if (imageFile != null) {
                    circular = true;
                  }
                });
                if (globalKey.currentState!.validate() && imageFile != null) {
                  Map<String, String> data = {
                    "name": nameController.text,
                    "profession": professionController.text,
                    "DOB": dobController.text,
                    "titleline": titleController.text,
                    "about": aboutController.text,
                  };
                  var response =
                      await networkHandler.post("/profile/add", data);
                  if (response.statusCode == 200 ||
                      response.statusCode == 201) {
                    if (imageFile != null) {
                      var imageResponse = await networkHandler.imagePatch(
                          "/profile/add/image", imageFile!.path);

                      if (imageResponse.statusCode == 200) {
                        setState(() {
                          circular = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Unable to upload image")));
                      }
                    } else {
                      setState(() {
                        circular = false;
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Add profile image")));
                }
              },
              child: Center(
                child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.teal,
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void pickImage(ImageSource source) async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: imageFile == null
                ? AssetImage('assets/profileimg.png')
                : FileImage(File(imageFile!.path)) as ImageProvider,
          ),
          Positioned(
              bottom: 20,
              right: 25,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: (context) => bottomSheet());
                },
                child: Icon(
                  Icons.camera,
                  size: 32,
                  color: Colors.green,
                ),
              )),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text("Choose profile photo"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  pickImage(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(width: 5),
                    Text("Camera", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              SizedBox(width: 20),
              TextButton(
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                    ),
                    SizedBox(width: 5),
                    Text("Gallery", style: TextStyle(color: Colors.black)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget nameTextField() {
    return TextFormField(
      controller: nameController,
      validator: (value) {
        if (value!.isEmpty) return "Name cannot be empty";
      },
      decoration: InputDecoration(
        labelText: "Name",
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.orange)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget DOBTextField() {
    return TextFormField(
      controller: dobController,
      validator: (value) {
        if (value!.isEmpty) return "Date of birth cannot be empty";
      },
      decoration: InputDecoration(
        labelText: "Date of Birth",
        hintText: "dd/mm/yyyy",
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.orange)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.date_range,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: professionController,
      validator: (value) {
        if (value!.isEmpty) return "Profession cannot be empty";
      },
      decoration: InputDecoration(
        labelText: "Profession",
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.orange)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.work,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: titleController,
      validator: (value) {
        if (value!.isEmpty) return "Title cannot be empty";
      },
      decoration: InputDecoration(
        labelText: "Title",
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.orange)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.title,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: aboutController,
      validator: (value) {
        if (value!.isEmpty) return "About cannot be empty";
      },
      maxLines: 4,
      decoration: InputDecoration(
        labelText: "About",
        helperText: "Write about yourself",
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.orange)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 2,
            )),
      ),
    );
  }
}
