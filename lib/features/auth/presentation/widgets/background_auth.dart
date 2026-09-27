import 'package:flutter/material.dart';

class BackGroundAuth extends StatelessWidget {
  const BackGroundAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: AssetImage('assets/images/app_images/train.jpg'),
        // ),
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.black38, Colors.black],
          tileMode: TileMode.decal,
          begin: Alignment.topCenter,
          end: AlignmentGeometry.bottomCenter,
        ),
      ),
      child: Opacity(
        opacity: .8,
        alwaysIncludeSemantics: true,
        child: Image.asset(
          'assets/images/app_images/train2.jpg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
