import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.text = "Loading..."});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitPumpingHeart(
              color: Colors.red,
              size: 100.0,
            ),
            Text(text),
          ],
        )
      ),
    );
  }
}