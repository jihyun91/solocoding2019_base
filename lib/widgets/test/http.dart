import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PostDetailPage extends StatefulWidget {
  @override
  _PostDetailPage createState() => _PostDetailPage();
}

// Model: Post
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class _PostDetailPage extends State<PostDetailPage> {
  Post postResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchPost().then((json) {
      print(json);
      postResult = json;
    });
  }

  // Service: fetchPost
  Future<Post> fetchPost() async {
    final url = 'https://jsonplaceholder.typicode.com/posts/1';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Post.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load post');
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          // Post Title
          Text(
            postResult.title,
            style: Theme.of(context).textTheme.title,
          ),
          // Post Body
          Text(
            postResult.body,
            style: Theme.of(context).textTheme.display1,
          )
        ],
      )
    );
  }
}