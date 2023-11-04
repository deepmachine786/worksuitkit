import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newapp/event_details.dart';

import 'package:newapp/search.dart';

Map listViewData = {};
String string = "";

class Home_Page extends StatefulWidget {
  @override
  _Home_Page createState() => _Home_Page();
}

class _Home_Page extends State<Home_Page> {
  bool _isLoading = true; // Change variable name to _isLoading
  // Store list data in a List

  Future<void> apicall() async {
    try {
      http.Response listResponse = await http.get(Uri.parse(
          "https://sde-007.api.assignment.theinternetfolks.works/v1/event"));

      if (listResponse.statusCode == 200) {
        setState(() {
          listViewData =
              json.decode(listResponse.body); // Store data in the list
          _isLoading = false; // Set isLoading to false when data is loaded
        });
      } else {
        await Future.delayed(const Duration(seconds: 10));
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Events",
          style: TextStyle(
            fontFamily: 'Events',
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF120D26),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the search page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search_Page()),
              );
            },
            icon: Icon(Icons.search),
            iconSize: 24,
          ),
          IconButton(
            onPressed: () {
              // Handle the action for the eclipse button
            },
            icon: Image.asset(
              "./assets/eclipse.png",
              height: 22,
              width: 22,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show circular loader
            )
          : listViewData.isEmpty
              ? Center(
                  child: Text(
                      'No data available'), // Show a message when data is empty
                )
              : ListView.builder(
                  itemCount: listViewData['content']['meta']['total'],
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          // Handle tap on the container, navigate to a new page
                          // and pass the data to that page.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return SecondPage(data: listViewData);
                              },
                            ),
                          );
                        },

                        // create a containerr....
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(31, 20, 31, 0),
                          color: Colors.white,
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: listViewData['content']['data']
                                        [index]['organiser_icon'],
                                    placeholder: (context, url) => SizedBox(
                                      height: 20.0, // Set the desired height
                                      width: 20.0, // Set the desired width
                                      child: CircularProgressIndicator(
                                        strokeWidth:
                                            2.0, // Adjust the thickness of the loader
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    height: 92,
                                    width: 79,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 13),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Mar 25, 21",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Inter',
                                                color: Color(0xFF5669FF),
                                              ),
                                            ),
                                            Image.asset("./assets/new_dot.png",
                                                height: 8,
                                                width: 8,
                                                fit: BoxFit.fill),
                                            Text(
                                              getstring(listViewData['content']
                                                  ['data'][index]['date_time']),
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Inter',
                                                color: Color(0xFF5669FF),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          listViewData['content']['data'][index]
                                              ['organiser_name'],
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Color(0xFF747688),
                                              size: 14,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              listViewData['content']['data']
                                                  [index]['venue_city'],
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                                color: Color(0xFF747688),
                                              ),
                                            ),
                                            Image.asset("./assets/dot.png",
                                                height: 9,
                                                width: 9,
                                                fit: BoxFit.fill),
                                            Text(
                                              listViewData['content']['data']
                                                  [index]['venue_country'],
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                                color: Color(0xFF747688),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ));
                  },
                ),
    );
  }

  String getstring(string) {
    return string.substring(string.length - 5) + " PM";
  }
}
