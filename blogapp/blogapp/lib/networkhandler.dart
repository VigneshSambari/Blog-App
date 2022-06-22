// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  FlutterSecureStorage storage = FlutterSecureStorage();

  String baseUrl = "http://192.168.217.89:2000";
  var log = Logger();

  Future<http.Response> post(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
    url = baseUrl + url;
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));

    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");
    url = baseUrl + url;
    var response = await http.patch(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));

    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    String? token = await storage.read(key: "token");
    url = baseUrl + url;
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));

    return response;
  }

  Future<dynamic> get(String url) async {
    String? token = await storage.read(key: "token");
    url = baseUrl + url;
    var response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.StreamedResponse> imagePatch(String url, String path) async {
    url = baseUrl + url;
    String? token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
    });
    var response = request.send();
    return response;
  }

  NetworkImage getImage(String username) {
    String url = baseUrl + "/uploads//$username.jpg";
    return NetworkImage(url);
  }
}
