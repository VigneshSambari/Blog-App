// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, deprecated_member_use, avoid_init_to_null, unnecessary_null_comparison

import 'dart:convert';

import 'package:blogapp/customwidget/overlaycard.dart';
import 'package:blogapp/model/addBlogModel.dart';
import 'package:blogapp/networkhandler.dart';
import 'package:blogapp/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final globalKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  ImagePicker picker = ImagePicker();
  PickedFile? image = null;
  IconData imageCheck = Icons.image;
  NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: TextButton(
                onPressed: () {
                  if (image != null &&
                      titleController.text != "" &&
                      bodyController.text != "") {
                    showModalBottomSheet(
                        context: context,
                        builder: (builder) => OverlayCard(
                              imageFile: image,
                              title: titleController.text,
                            ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Upload image, title and body to preview")));
                  }
                },
                child: Text(
                  "Preview",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
          )
        ],
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
          color: Colors.black54,
        ),
      ),
      body: Form(
        key: globalKey,
        child: ListView(
          children: [titleText(), bodyText(), SizedBox(height: 12.5), button()],
        ),
      ),
    );
  }

  Widget titleText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextFormField(
        controller: titleController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Title cannot be empty";
          } else if (value.length > 100) {
            return "Title cannot have more than 100 characters";
          }
          return null;
        },
        maxLength: 100,
        maxLines: null,
        decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(
                imageCheck,
                color: Colors.teal,
              ),
              onPressed: () {
                takeCoverPhoto();
              },
            ),
            labelText: "Add image and title",
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
            ))),
      ),
    );
  }

  Widget bodyText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: bodyController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Body cannot be empty";
          }
          return null;
        },
        minLines: 5,
        maxLines: null,
        decoration: InputDecoration(
            labelText: "Add blog info.",
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2)),
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.teal,
            ))),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () async {
        if (globalKey.currentState!.validate() && image != null) {
          AddBlogModel addBlogModel = AddBlogModel(
              title: titleController.text, body: bodyController.text);
          var response = await networkHandler.post1(
              "/blogpost/Add", addBlogModel.toJson());

          if (response.statusCode == 200 || response.statusCode == 201) {
            String id = json.decode(response.body)["data"];
            var imageResponse = await networkHandler.imagePatch(
                "/blogpost/add/coverImage/$id", image!.path);
            if (imageResponse.statusCode == 200 ||
                imageResponse.statusCode == 201) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            }
          }
        }
      },
      child: Center(
        child: Container(
          child: Center(
            child: Text(
              "Add Blog",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.teal, borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void takeCoverPhoto() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = pickedImage;
      imageCheck = Icons.check_box;
    });
  }
}
