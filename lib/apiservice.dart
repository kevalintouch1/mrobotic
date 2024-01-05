import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService with ChangeNotifier {
  final String url = 'https://apisolar.aviquon.com';

  Future<Map<String, dynamic>> getCall(String slug) async {
    try {
      final response = await http.get(Uri.parse('$url$slug'));
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> postCall(
      String slug, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$url$slug'),
        body: data,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> patchCall(
      String slug, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$url$slug'),
        body: data,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> tokenWithPostCall(
      String slug, Map<String, dynamic> data, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$url$slug'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> tokenWithPostCall2(
      String slug, Map<String, dynamic> data, String token) async {
    try {
      var uri = Uri.parse('$url$slug');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';

      // Add your fields to the request
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Send the request and get the response
      var response = await http.Response.fromStream(await request.send());
      Map<String, dynamic> json = jsonDecode(response.body);
      return json;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> tokenWithPostCall3(
      String slug, Map<String, dynamic> data, String token) async {
    String requestBodyJson = jsonEncode(data);

    // Make the POST request
    try {
      var uri = Uri.parse('$url$slug');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        // Successfully posted data
        print('Data posted successfully');
        print('Response: ${response.body}');
        Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        // Handle the error
        print('Failed to post data. Status code: ${response.statusCode}');
        print('Error: ${response.headers}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during POST request: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> tokenWithPostCall4(
      String slug, String userid, String paths, String token) async {
    try {
      var uri = Uri.parse('$url$slug');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';

      request.fields['UserId'] = userid;

      final imageFile = await http.MultipartFile.fromPath(
        'File',
        paths,
      );

      request.files.add(imageFile);

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      print('Server Response: $responseData');

      // Send the request and get the response
      Map<String, dynamic> json = jsonDecode(responseData);
      return json;
    } catch (e) {
      print('Server errr: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> tokenWithGetCall(
      String slug, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$url$slug'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> connectRobot(
      String slug, Map<String, dynamic> data) async {
    try {
      print('slug $slug');
      final response = await http.post(
        Uri.parse(slug),
        body: data,
      );
      print('response ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return json;
      } else {
        print('error1 $response');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('error2 $e');
      throw Exception(e);
    }
  }
}
