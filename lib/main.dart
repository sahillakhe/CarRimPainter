import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paint_over/image_painter.dart';
import 'package:image/image.dart' as image;
import 'package:flutter/services.dart';

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
  ui.Image uiImage;
  Future<File> getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile.path);
    uiImage = await getUiImage(_image.path, 400, 400);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: GestureDetector(
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
            painter: ImagePainter(
              _offsets,
              _scaleRadius,
              uiImage,
              context
            ),
            child: Container(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
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
        child: Icon(Icons.photo_album),
      ),
    );
  }
}

Future<ui.Image> getUiImage(String imagePath, int height, int width) async {
  final ByteData assetImageByteData = await rootBundle.load(imagePath);
  image.Image baseSizeImage =
      image.decodeImage(assetImageByteData.buffer.asUint8List());
  image.Image resizeImage =
      image.copyResize(baseSizeImage, height: height, width: width);
  ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
  frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}
