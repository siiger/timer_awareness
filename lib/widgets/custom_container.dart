import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String labelText;
  final BoxDecoration decoration;
  final Widget child;
  final double width;
  final double height;

  const CustomContainer(
      {this.labelText, this.decoration, this.child, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 80,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: width,
            height: height,
            decoration: decoration,
            child: child,
          ),
        ),
        Positioned(
          left: 10,
          bottom: 40,
          child: Center(
              child: Container(color: Colors.white, child: Text('$labelText'))),
        )
      ],
    );
  }
}
