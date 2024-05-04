import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(230, 1, 1, 21), // Set background color to black
        child: Center(
          child: Image.asset(
            'assets/logo.png', // Replace 'your_logo.png' with the actual path to your logo image asset
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
