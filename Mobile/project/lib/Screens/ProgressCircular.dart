import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;

class MyPainter extends CustomPainter {
  MyPainter({required this.rate});
  final double rate;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue..strokeCap = StrokeCap.round..style = PaintingStyle.stroke..strokeWidth = 10;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      -math.pi/2,
      2*math.pi*rate,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ProgressCircular extends StatefulWidget {
  ProgressCircular({super.key, this.time = 100, this.text = "Loading..."});
  final String text;
  final double time;
  final double startTime = DateTime.now().millisecondsSinceEpoch.toDouble();
  @override
  State<ProgressCircular> createState() => _ProgressCircularState();
}

class _ProgressCircularState extends State<ProgressCircular> {
  @override
  double rate = 0;
  double size = 80;
  Widget build(BuildContext context) {
    runtime();
    print(rate);
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCircle(
              color: Colors.blue,
              size: 1.0,
            ),
            Stack(
              children: [
                CustomPaint(
                painter: MyPainter(rate: rate),
                size: Size(size, size), 
                ),
                Container(
                  child: Text((rate*100).ceil().toString()+"%"),
                  height: size,
                  width: size,
                  alignment: Alignment.center,
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text("    Measuring\nPlease waiting..."),
          ],
        )
      ),
    );
  }

  void runtime() async {
    await Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          rate = (DateTime.now().millisecondsSinceEpoch.toDouble() - widget.startTime)/(widget.time);
          if ((rate*100).ceil()>=100 ) {
            rate = 1;
          }
        });
      }
    });
  }
}
