import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //this list you can add and delete objects to but cannot delete list
  final _offsets = <Offset>[];
  Offset lastOffset;
  Offset localPoint;
  double _scaleRadius = 100.0;
  double _baseRadius = 1.0;
  final ImagePicker _picker = ImagePicker();

  File _image;
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: GestureDetector(
        // onPanStart: (DragStartDetails details) {
        //   print("globalDetailsStart: ${details.globalPosition}");
        //   setState(() {
        //     _offsets.add(details.globalPosition);
        //   });
        // },
        // onPanUpdate: (DragUpdateDetails details) {
        //   setState(() {
        //     // _offsets.clear();
        //     // _offsets.add(details.globalPosition);

        //     lastOffset = details.globalPosition;
        //   });
        // },
        // onPanEnd: (DragEndDetails details) {
        //   // _offsets.add(lastOffset);
        // },
        onScaleStart: (ScaleStartDetails details) {
          setState(() {
            _offsets.clear();
            _offsets.add(details.localFocalPoint);
            _baseRadius = _scaleRadius;
          });
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _offsets.clear();
            _offsets.add(details.localFocalPoint);
            _scaleRadius = _baseRadius * details.scale;
          });
        },
        child: Center(
          child: CustomPaint(
            painter: FlipBookPainter(
              _offsets,
              _scaleRadius,
            ),
            child: Container(
              child: Center(
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
              ),
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     image: Decoration
            //   ),
            // color: Colors.red[50],
            // ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class FlipBookPainter extends CustomPainter {
  final offsets;
  final radius;

  FlipBookPainter(this.offsets, this.radius) : super();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(255, 0, 255, 0.1)
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;
    // canvas.drawPoints(
    //   PointMode.lines,
    //   offsets,
    //   paint,
    // );
    // canvas.drawImage(image, offset, paint);
    for (var offset in offsets) {
      print("offset: ${offset}");

      canvas.drawCircle(
        offset,
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
