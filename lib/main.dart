
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tools/sub.dart';
import 'package:tools/voice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    double Hei = Height * 0.3;
    double Wid = Width * 0.15;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F5),
        title: Row(children: [
          Text('tools'),
          SizedBox(
                width: Width * 0.1,

              ),
              TextButton(onPressed: (){
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Voice(),
          ),
        );
              }, child: Text('Files')),
              SizedBox(
                width: Width * 0.1,

              ),
              TextButton(onPressed: (){
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Voice(),
          ),
        );
              }, child: Text('Audio')),
              SizedBox(
                width: Width * 0.1,

              ),
              TextButton(onPressed: (){
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Voice(),
          ),
        );
              }, child: Text('Image')),
              SizedBox(
                width: Width * 0.1,

              ),
              TextButton(onPressed: (){
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Voice(),
          ),
        );
              }, child: Text('Video')),
        ],),
        elevation: 4.0, // Adds shadow to the AppBar
        shadowColor:
            Colors.grey.withOpacity(0.5), // Customize shadow color if needed
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: Height * 0.05,
              ),
              Center(
                child: Text(
                  "Every tool you need to work with PDFs in one place",
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: SizedBox(
                  width: Width * 0.6,
                  child: Text(
                      "Every tool you need to use PDFs, at your fingertips. All are 100% FREE and easy to use! Merge, split, compress, convert, rotate, unlock and watermark PDFs with just a few clicks.",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ),
              ),
              SizedBox(
                height: Height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.1,
                  ),
                  buildContainer(Hei, Wid, "Merge PDF"),
                  buildContainer(Hei, Wid, "Split PDF"),
                  buildContainer(Hei, Wid, "Remove pages"),
                  buildContainer(Hei, Wid, "Extract pages"),
                  SizedBox(
                    width: Width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.1,
                  ),
                  buildContainer(Hei, Wid, "Organize PDF"),
                  buildContainer(Hei, Wid, "Scan to PDF"),
                  buildContainer(Hei, Wid, "Compress PDF"),
                  buildContainer(Hei, Wid, "Repair PDF"),
                  SizedBox(
                    width: Width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.1,
                  ),
                  buildContainer(Hei, Wid, "OCR PDF"),
                  buildContainer(Hei, Wid, "JPG to PDF"),
                  buildContainer(Hei, Wid, "WORD to PDF"),
                  buildContainer(Hei, Wid, "POWERPOINT to PDF"),
                  SizedBox(
                    width: Width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.1,
                  ),
                  buildContainer(Hei, Wid, "EXCEL to PDF"),
                  buildContainer(Hei, Wid, "HTML to PDF"),
                  buildContainer(Hei, Wid, "PDF to JPG"),
                  buildContainer(Hei, Wid, "PDF to WORD"),
                  SizedBox(
                    width: Width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.1,
                  ),
                  buildContainer(Hei, Wid, "PDF to POWERPOINT"),
                  buildContainer(Hei, Wid, "PDF to EXCEL"),
                  buildContainer(Hei, Wid, "PDF to PDF/A"),
                  buildContainer(Hei, Wid, "Rotate PDF"),
                  SizedBox(
                    width: Width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.1,
                  ),
                  buildContainer(Hei, Wid, "Add page numbers"),
                  buildContainer(Hei, Wid, "Add watermark"),
                  buildContainer(Hei, Wid, "Edit PDF"),
                  buildContainer(Hei, Wid, "Unlock PDF"),
                  SizedBox(
                    width: Width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Width * 0.1,
                  ),
                  buildContainer(Hei, Wid, "Protect PDF"),
                  buildContainer(Hei, Wid, "Sign PDF"),
                  buildContainer(Hei, Wid, "Redact PDF"),
                  buildContainer(Hei, Wid, "Compare PDF"),
                  SizedBox(
                    width: Width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: Height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer(double height, double width, String text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewScreen(title: text),
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Color(0xFF8EE4AF),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(color: Color(0xFF2C2C2C)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

