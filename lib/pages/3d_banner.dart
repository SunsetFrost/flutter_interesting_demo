import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  double backgroundScale = 1.3;
  double middleScale = 1.0;
  double foregroundScale = 1.1;
  double width = 0;
  double height = 0;
  double maxAngleX = 50;
  double maxAngleY = 40;
  Offset backgroundOffset = const Offset(0.1, 0.1);
  Offset foregroundOffset = const Offset(0.1, 0.1);
  double time = 0.02;

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    _startGyroscope();

    super.initState();
  }

  // 初始化陀螺仪
  Future<void> _startGyroscope() async {
    // sensor stream
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.GYROSCOPE,
      interval: Sensors.SENSOR_DELAY_GAME,
    );

    _streamSubscription = stream.listen((event) {
      setState(() {
        Offset deltaOffset = gyroscopeToOffset(-event.data[1], -event.data[0]);
        backgroundOffset = considerBoundary(deltaOffset + backgroundOffset);
        foregroundOffset = getForegroundOffsetByBg(backgroundOffset);
      });
    });
  }

  // 陀螺仪 to offset
  Offset gyroscopeToOffset(double x, double y) {
    double angleX = x * time * 180 / pi;
    double angleY = y * time * 180 / pi;
    // print('x is $angleX');
    // print('y is $angleY');
    angleX = angleX >= maxAngleX ? maxAngleX : angleX;
    angleY = angleY >= maxAngleY ? maxAngleY : angleY;
    double offsetX = angleX / maxAngleX * maxOffsetOfBackground.dx;
    double offsetY = angleY / maxAngleY * maxOffsetOfBackground.dy;

    return Offset(offsetX, offsetY);
  }

  // 通过最大偏移约束计算偏移量
  Offset considerBoundary(Offset origin) {
    Offset maxOffset = maxOffsetOfBackground;
    double dx = origin.dx;
    double dy = origin.dy;
    if (dx > maxOffset.dx) {
      dx = maxOffset.dx;
    }
    if (origin.dx < -maxOffset.dx) {
      dx = -maxOffset.dx;
    }

    if (dy > maxOffset.dy) {
      dy = maxOffset.dy;
    }
    if (origin.dy < -maxOffset.dy) {
      dy = -maxOffset.dy;
    }
    Offset result = Offset(dx, dy);
    return result;
  }

  // 背景层最大偏移量
  Offset get maxOffsetOfBackground {
    final x = (backgroundScale - 1.0) * width / 2;
    final y = (backgroundScale - 1.0) * height / 2;
    return Offset(x, y);
  }

  // 由背景层最大偏移量推算前景层偏移量
  Offset getForegroundOffsetByBg(Offset backgroundOffset) {
    final double offsetRate = (foregroundScale - 1) / (backgroundScale - 1);
    return -Offset(
        backgroundOffset.dx * offsetRate, backgroundOffset.dy * offsetRate);
  }

  @override
  void dispose() {
    if (_streamSubscription == null) return;
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = 200;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned(
                top: backgroundOffset.dy,
                left: backgroundOffset.dx,
                child: Transform.scale(
                    scale: backgroundScale,
                    child: Image.asset(
                      'assets/banner/back.png',
                      width: width,
                      height: height,
                      fit: BoxFit.fill,
                      // scale: 3.0,
                    )),
              ),
              Positioned(
                child: Transform.scale(
                    scale: middleScale,
                    child: Image.asset(
                      'assets/banner/mid.png',
                      width: width,
                      height: height,
                      fit: BoxFit.fill,
                      // scale: 3.0,
                    )),
              ),
              Positioned(
                top: foregroundOffset.dy,
                left: foregroundOffset.dx,
                child: Transform.scale(
                    scale: foregroundScale,
                    child: Image.asset(
                      'assets/banner/fore.png',
                      width: width,
                      height: height,
                      fit: BoxFit.fill,
                      // scale: 3.0,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
