import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chatty/utils/utils.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  String _message = '';
  FlutterPusher? pusher;
  Echo? echo;
  Map<String, String> headers = {'content-type': 'application/json'};

  @override
  void initState() {
    super.initState();

    initilizeSocket();
  }

  void initilizeSocket() {
    pusher = initializePusher();

    echo = initializeEcho(pusher!);

    echo!.channel('home').listen('SendMessage', (e) {
      setState(() {
        _message = e['message'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(hintText: 'Write a Message'),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Text(_message)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () => sendMessage(context),
      ),
    );
  }

  Future<void> sendMessage(BuildContext context) async {
    Uri uri = Uri.parse("$scheme://$host:8000/api/send");

    if (_textController.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please Write a Message...")));
      return;
    }

    http.Response response = await http.post(uri,
        headers: headers, body: jsonEncode({'data': _textController.text}));

    print(response.statusCode);
  }

  @override
  void dispose() {
    super.dispose();
    echo!.channel('home').stopListening('SendMessage');
    echo!.channel('home').unsubscribe();
  }
}
