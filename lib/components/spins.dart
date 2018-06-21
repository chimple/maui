import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final double rotationPercent;
  Size sizeArrow;
  ArrowPainter({
    this.rotationPercent,
    this.sizeArrow,
  }) : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.blue[50];
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final radius = size.width;
    canvas.translate(radius, radius);
    print("canvas size:: ${sizeArrow.width}");
    Path path = new Path();
    path.moveTo(0.0, -sizeArrow.width * .31);
    path.lineTo(sizeArrow.width * .35 * .17, -0.0);
    path.lineTo(-sizeArrow.width * .35 * .17, -0.0);

    path.close();
    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.red[300], 30.0, true);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class OuterCircle extends CustomPainter {
  final LONG_TICK = 50.0;
  final SHORT_TICK = 4.0;
  List<String> data;
  double sizePaint;
  final Paint traingle;
  final double rotationPercent;
  List<int> outerCircle = [1, 10, 3, 2, 3, 4, 15, 25, 3, 32, 5, 6, 6, 7, 4];
  final tickCount;
  final ticksPerSection;
  final ticksInset;
  final tickPaint;
  final textPainter;
  final textStyle;
  final image;
  final buttonStyle;
  OuterCircle({
    this.data,
    this.sizePaint: 0.0,
    this.tickCount = 35,
    this.ticksPerSection = 0.0,
    this.ticksInset = 0.0,
  })  : tickPaint = new Paint(),
        traingle = new Paint(),
        textPainter = new TextPainter(
          maxLines: 10,
          //ellipsis:'sa',
          textScaleFactor: 1.30,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
        ),
        buttonStyle = new Container(
          width: 30.0,
          height: 30.0,
        ) {
    tickPaint.strokeWidth = 2.5;
    traingle.color = Colors.black;
    traingle.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    canvas.rotate(-ticksPerSection);
    final radius = size.width / 2;

    Rect myRect = const Offset(0.0, 0.0) & Size(size.width / 2, size.width / 2);

    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.lineTo(-2 * pi * size.width / 2 / 16, size.width / 2 - 20);

    path.close();
    int c = 0;

    for (var i = 0; i < 16; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
      if (i % 2 == 0) {
        // canvas.drawLine(
        //   new Offset(0.0, 0.0),
        //   new Offset(0.0, radius - 4.2),
        //   tickPaint,
        // );
      } else {
        canvas.save();
        canvas.translate(-0.0, -((size.width) / 3));
        String s = data[c];
        textPainter.text = new TextSpan(
          text: s,
          style: textStyle,
        );
        c++;

        textPainter.layout();

        canvas.rotate(2 * pi / 2);
        textPainter.paint(
          canvas,
          new Offset(
            0.0,
            (textPainter.height) / 3,
          ),
        );

        canvas.restore();
      }
      canvas.rotate(2 * pi / 16);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ImageData1 extends CustomPainter {
  final LONG_TICK = 50.0;
  final SHORT_TICK = 4.0;
  List<String> data;
  double sizePaint;
  final Paint traingle;
  final double rotationPercent;
  List<int> outerCircle = [1, 10, 3, 2, 3, 4, 15, 25, 3, 32, 5, 6, 6, 7, 4];
  final tickCount;
  final ticksPerSection;
  final ticksInset;
  final tickPaint;
  final textPainter;
  final textStyle;
  final image;
  final buttonStyle;
  
  ImageData1({
    this.data,
    this.sizePaint: 0.0,
    this.tickCount = 35,
    this.ticksPerSection = 0.0,
    this.ticksInset = 0.0,
  })  : tickPaint = new Paint(),
        traingle = new Paint(),
        image =new Image(image: AssetImage('assets/hoodie/fill_in_the_blanks.png'),);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    canvas.rotate(-ticksPerSection);

    canvas.drawImage(image, new Offset(10.0, 200.0), tickPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class ImageData extends CustomPainter {
  //final ui.Image image;

  ImageData();
  
  ui.Image image;
  @override
  void paint(ui.Canvas canvas, ui.Size size) async {
    
    // ImageMap images = new ImageMap(rootBundle);
    // image = await images.loadImage('assets/koala_happy.png');
    canvas.drawImage(image, ui.Offset.zero, new Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// class InnerCircle extends CustomPainter {
//   final LONG_TICK = 50.0;
//   final SHORT_TICK = 4.0;
//   double sizePaint;
//   final tickCount;
//   final ticksPerSection1;
//   final ticksInset;
//   final tickPaint;
//   final textPainter;
//   final textStyle;

//   InnerCircle({
//     this.tickCount = 35,
//     this.ticksPerSection1 = 0.0,
//     this.ticksInset = 0.0,
//   })  : tickPaint = new Paint(),
//         textPainter = new TextPainter(
//           textAlign: TextAlign.center,
//           textDirection: TextDirection.rtl,
//         ),
//         textStyle = const TextStyle(
//           color: Colors.black,
//           fontFamily: 'BebasNeue',
//           fontSize: 20.0,
//         ) {
//     tickPaint.color = Colors.black;
//     tickPaint.strokeWidth = 0.5;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.translate(size.width / 2, size.height / 2);

//     canvas.save();
//     canvas.rotate(-ticksPerSection1);
//     final radius = size.width / 2;
//     print("Inner Container:: $size");
//     for (var i = 0; i < 16; ++i) {
//       //final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
//       if (i % 2 == 0) {
//         // canvas.drawLine(
//         //   new Offset(0.0, 0.0),
//         //   new Offset(0.0, radius),
//         //   tickPaint,
//         // );
//       } else {
//         canvas.save();
//         canvas.translate(-0.0, -(size.width / 4));

//         textPainter.text = new TextSpan(
//           text: '$i',
//           style: textStyle,
//         );
//         textPainter.layout();

//         canvas.rotate(2 * pi / 2);
//         textPainter.paint(
//           canvas,
//           new Offset(
//             0.0,
//             textPainter.height / 2,
//           ),
//         );

//         canvas.restore();
//       }
//       canvas.rotate(2 * pi / 16);
//     }

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
