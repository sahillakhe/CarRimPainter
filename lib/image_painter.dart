import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

ui.FrameInfo frameInfo;

class ImagePainter extends CustomPainter {
  final offsets;
  final radius;
  ui.Image _image;
  BuildContext context;

  ImagePainter(this.offsets, this.radius, this._image, this.context) : super();
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) async {
    final paint = Paint();
    // ..color = Color.fromRGBO(255, 0, 255, 0.1)
    // ..isAntiAlias = true
    // ..strokeWidth = 1.0
    // ..style = PaintingStyle.fill;

    if (_image != null) {
      print("_image is not null. radius: $radius");
      

      // canvas.drawImage(_image, Offset.zero, paint);
      // canvas.scale(radius);
      var screenHeight = MediaQuery.of(context).size.height;
      var screenWidth = MediaQuery.of(context).size.width;
      double scale = 1 / radius;
      // var top
      paintImage(
          canvas: canvas,
          image: _image,
          rect: Rect.fromLTWH(0, 0, screenWidth, screenHeight),
          // fit: BoxFit.scaleDown,
          scale: 1);
    } else {
      print("No image");
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
