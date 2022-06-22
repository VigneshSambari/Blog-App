// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:blogapp/blogs/blog.dart';
import 'package:blogapp/customwidget/blogcard.dart';
import 'package:blogapp/model/addBlogModel.dart';
import 'package:blogapp/model/superModel.dart';
import 'package:blogapp/networkhandler.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  Blogs({this.url});
  final String? url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  SuperModel superModel = SuperModel();
  List<AddBlogModel> data = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await networkHandler.get(widget.url!);
    superModel = SuperModel.fromJson(response);
    setState(() {
      data = superModel.data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: Text("We dont have any blogs yet"),
          )
        : Column(
            children: data
                .map((item) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Blog(
                                      addBlogModel: item,
                                    )));
                          },
                          child: BlogCard(
                            addBlogModel: item,
                            networkHandler: networkHandler,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ))
                .toList(),
          );
  }
}
