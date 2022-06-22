// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors, unused_import, must_be_immutable, prefer_const_constructors_in_immutables

import 'dart:io';

import 'package:blogapp/model/addBlogModel.dart';
import 'package:blogapp/networkhandler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BlogCard extends StatelessWidget {
  BlogCard({this.addBlogModel, this.networkHandler});
  final AddBlogModel? addBlogModel;
  final NetworkHandler? networkHandler;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: networkHandler!.getImage(addBlogModel!.id),
              )),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  addBlogModel!.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            )
          ],
        ));
  }
}
