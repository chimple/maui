import 'package:flutter/widgets.dart';

class Stars extends StatelessWidget {
  final int total;
  final int show;

  const Stars({Key key, this.total, this.show}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(
        total,
        (int index) => Flexible(
          
              child: Image.asset(index < show
                  ? 'assets/star_gained.png'
                  : 'assets/star.png'),
            ),
      ),
    );
  }
}
