import 'package:flutter/material.dart';

import 'package:flutter_interesting_demo/pages/3d_banner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Interesting Demo',
      theme: ThemeData(
          // primarySwatch: Colors.,
          ),
      debugShowCheckedModeBanner: false,
      home: const IndexPage(),
      routes: <String, WidgetBuilder>{
        '/banner': (BuildContext context) => const BannerPage(),
      },
    );
  }
}

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/banner');
                  },
                  child: const Text('3d banner'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('lottie animation'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('river animation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
