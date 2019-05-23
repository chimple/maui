import 'package:flutter/material.dart';
import 'package:maui/util/texture_text.dart';
import 'package:storyboard/storyboard.dart';

class TextureTextStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
            body: SafeArea(
                child: TextureText(
          text: 'English',
          texture: 'texture1',
        ))),
        Scaffold(
            body: SafeArea(
                child: TextureText(
          text: 'हिन्दी',
          texture: 'texture2',
        ))),
        Scaffold(
            body: SafeArea(
                child: TextureText(
          text: 'ଓଡ଼ିଆ',
          texture: 'texture3',
        ))),
        Scaffold(
            body: SafeArea(
                child: TextureText(
          text: 'ଓଡ଼ିଆ',
          texture: 'texture4',
        )))
      ];
}
