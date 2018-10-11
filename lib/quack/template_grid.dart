import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/repos/card_extra_repo.dart';
import 'package:tahiti/popup_grid_view.dart';

class TemplateGrid extends StatelessWidget {
  final String cardId;
  final List<String> templates;

  TemplateGrid({key, this.cardId, this.templates}) : super(key: key);

  Widget _buildTile(BuildContext context, String template) {
    return Card(
      elevation: 5.0,
      child: new InkWell(
        onTap: () => Navigator.pop(context, template),
        child: new AspectRatio(
          aspectRatio: 1.0,
          child: template.endsWith('.svg')
              ? new SvgPicture.asset(
                  template,
                )
              : Image.asset(
                  template,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children:
          templates.map((t) => _buildTile(context, t)).toList(growable: false),
    );
  }
}
