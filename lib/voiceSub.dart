import 'package:flutter/material.dart';
import 'dart:html' as html;

class ExtractAudioScreen extends StatefulWidget {
  @override
  _ExtractAudioScreenState createState() => _ExtractAudioScreenState();
}

class _ExtractAudioScreenState extends State<ExtractAudioScreen> {
  final TextEditingController _controller = TextEditingController();
  String? downloadUrl;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extract Audio from YouTube')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter YouTube Video URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){},
              child: Text('Extract Audio'),
            ),
            if (downloadUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Audio file ready for download.',
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
