import 'package:eng_story/res/custom_colors.dart';
import 'package:flutter/material.dart';


class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo_campany.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'English',
          style: TextStyle(
            color: CustomColors.colorYellow,
            fontSize: 18,
          ),
        ),
        Text(
          ' Story',
          style: TextStyle(
            color: CustomColors.colorOrange,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}