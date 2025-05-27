import 'package:fitnes_ptnit/screens/Home.dart';
import 'package:fitnes_ptnit/screens/Kelas.dart';
import 'package:fitnes_ptnit/screens/Profil.dart'; 
import 'package:fitnes_ptnit/screens/Workout.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

const Color darkBluePrimary =
    Color.fromARGB(255, 0, 7, 65); 
const Color lightBlueAccent =
    Color.fromARGB(255, 171, 213, 255); 
const Color pureWhite =
    Colors.white; 


const Color lightBackgroundBlue =
    Color(0xFFF0F4F8);
const Color textColorDark = Color(
    0xFF2C3E50);
const Color textColorMedium =
    Color(0xFF5E6B7E); 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        primaryColor: darkBluePrimary, 
        hintColor: lightBlueAccent,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor:
            lightBackgroundBlue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor:
              textColorDark, 
          elevation: 0, 
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColorDark, 
          ),
        ),
        textTheme:
            GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: textColorDark, 
          displayColor: textColorDark, 
        ),
      ),
      home: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    WorkoutScreen(),
    KelasScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: pureWhite, 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25)), 
        ),
        child: SalomonBottomBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          unselectedItemColor:
              darkBluePrimary, 
          selectedItemColor:
              lightBlueAccent,
          margin: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 15),
          itemPadding: const EdgeInsets.symmetric(
              horizontal: 18, vertical: 10), 
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_rounded),
              title: Text(
                'Home',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              selectedColor:
                  darkBluePrimary, 
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.fitness_center_rounded),
              title: Text(
                'Workout',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              selectedColor:
                  darkBluePrimary, 
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.group_work_rounded),
              title: Text(
                'Kelas',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              selectedColor:
                  darkBluePrimary, 
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_rounded),
              title: Text(
                'Profil',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              selectedColor:
                  darkBluePrimary, 
            ),
          ],
        ),
      ),
    );
  }
}
