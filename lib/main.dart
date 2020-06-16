import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'dart:async';

Future<Album> fetchAlbum() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if(response.statusCode==200)
    return Album.fromJson(json.decode(response.body));
  else
    throw Exception('Failed to load album');
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId,this.id,this.title});
  
  factory Album.fromJson(Map<String,dynamic> json){
   return Album(
     userId: json['userId'],
     id: json['id'],
     title: json['title'],
   );
  }
}

void main() => runApp(
  MaterialApp(
    home:MyApp(),
  )
);

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;

  @override
  void initState(){
    super.initState();
    futureAlbum=fetchAlbum();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch data'),
      ),
      body: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return Text(snapshot.data.title);
            }
            else if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        )
      ),
    );
  }
}