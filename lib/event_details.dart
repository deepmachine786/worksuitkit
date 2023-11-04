import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SecondPage extends StatelessWidget {
  Map data; // ata passed from the first page

  SecondPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  // Replace with your banner image
                  image: AssetImage(data['content']['data'][0]['banner_image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        body: Container(child: Text(data['content']['data']['title'])));
  }
}
