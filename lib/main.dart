import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

void main() {
  Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

var cmd;
var fsconnect = FirebaseFirestore.instance;
myget() async {
  var d = await fsconnect
      .collection("linuxcmds")
      .where('command', isEqualTo: cmd)
      .snapshots()
      .listen((data) => print('${data.docs[0].data()}'));
}

var data;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  mydata() async {
    //print("Button pressed");
    var url = "http://13.233.85.29/cgi-bin/my.py/?x=$cmd";
    var r = await http.get(url);

    setState(() {
      data = r.body;
    });

    var x = fsconnect.collection("linuxcmds").add({
      'command': cmd,
      'output': data,
    });
    print("My data is inserted in the database Successfully");
    myget();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('My Linux CLI APP'),
          ),
          body: Column(
            children: <Widget>[
              Text("Welcome to my app"),
              TextField(
                autocorrect: false,
                onChanged: (value) {
                  cmd = value;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Your CMD",
                  prefixIcon: Icon(Icons.smartphone),
                ),
              ),
              FlatButton(
                child: Text("Submit"),
                onPressed: mydata,
              ),
              Text(data ?? "Output is coming"),
            ],
          )),
    );
  }
}
