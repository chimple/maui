import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class TextureText extends StatefulWidget {
  final String text;
  final String texture;
  final double fontSize;
  TextureText({this.text, this.texture, this.fontSize = 150}) : super();
  @override
  _TextureTextState createState() => new _TextureTextState();
}

class _TextureTextState extends State<TextureText> {
  TextStyle textStyle = TextStyle();
  @override
  void initState() {
    super.initState();
    textureText();
  }

  textureText() async {
    final double devicePixelRatio = ui.window.devicePixelRatio;
    ui.Image image;
    ByteData data =
        await rootBundle.load("assets/texture/${widget.texture}.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    image = fi.image;
    final Float64List float64list = new Float64List(16)
      ..[0] = devicePixelRatio
      ..[5] = devicePixelRatio
      ..[10] = 4.40
      ..[15] = 5.40;
    textStyle = textStyle.copyWith(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w800,
        foreground: Paint()
          ..shader = ImageShader(
              image, TileMode.repeated, TileMode.repeated, float64list));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Text(widget.text, style: textStyle ?? TextStyle(fontSize: 50));
}
