import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teman_fitness/bottom_nav_bar.dart';
import 'package:teman_fitness/screens/Login.dart';

const Color darkBluePrimary = Color.fromARGB(255, 0, 7, 65);
const Color lightBlueAccent = Color.fromARGB(255, 171, 213, 255);
const Color pureWhite = Colors.white;
const Color darkNavyCustom = Color(0xFF0D1B2A);

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => BottomNavBar()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBluePrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!',
              style: GoogleFonts.poppins(
                color: pureWhite.withOpacity(0.8),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Image.asset(
              'assets/logo.png',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 25),
            Text(
              'TEMAN FITNESS',
              style: GoogleFonts.poppins(
                color: pureWhite,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 50),
            CircularProgressIndicator(
              color: lightBlueAccent,
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
