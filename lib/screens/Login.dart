import 'dart:convert';
import 'package:teman_fitness/config/app_config.dart';
import 'package:teman_fitness/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

// --- Palet Warna Energi & Motivasi (Konsisten dengan ProfileScreen) ---
const Color primaryRed = Color(0xFFE63946); // Merah Cerah (Primer)
const Color accentOrange = Color(0xFFFF7F11); // Oranye Cerah (Aksen)
const Color darkNavy =
    Color(0xFF0D1B2A); // Biru Dongker / Navy (Untuk teks gelap atau aksen kuat)
const Color lightBackground =
    Color(0xFFF7F7F7); // Latar belakang umum yang terang
const Color textColorDark =
    Color(0xFF333333); // Teks gelap pada latar belakang terang
const Color textColorMedium =
    Color(0xFF757575); // Teks sedang pada latar belakang terang

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Email dan password tidak boleh kosong", isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('${AppConfig.baseUrl}/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final user = data['user'];

        await _saveLoginStatus(true);
        await _saveToken(token);
        await _saveEmail(user['email'] ?? email);
        await _saveName(user['name'] ?? '');
        await _savePhone(user['phone'] ?? '');
        await _saveStatus(user['status'] ?? '');

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SplashScreen()),
        );
      } else {
        final error = jsonDecode(response.body);
        if (!mounted) return;
        _showSnackBar(error['message'] ?? "Email atau password salah",
            isError: true);
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan: $e", isError: true);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor:
            isError ? primaryRed : accentOrange, // Warna SnackBar sesuai status
        behavior: SnackBarBehavior.floating, // Tampilan floating
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<void> _saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  Future<void> _savePhone(String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', phone);
  }

  Future<void> _saveStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_status', status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Background Gradien Energi & Motivasi ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 7, 65), // Warna gelap di atas
                  Color.fromARGB(255, 171, 213, 255), // Warna terang di bawah
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 180,
                    height: 180,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Teman Fitness',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'Platform fitness Gen-Z untuk gaya hidup sehat yang seru dan terjangkau!',
                    textAlign:
                        TextAlign.center, // Slogan atau deskripsi singkat
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 48), // Spasi lebih besar

                  // --- Input Field (Email) ---
                  _buildInputField(
                    controller: emailController,
                    hintText: "Email",
                    icon: Icons.email_rounded, // Menggunakan ikon rounded
                  ),
                  const SizedBox(height: 16),

                  // --- Input Field (Password) ---
                  _buildInputField(
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock_rounded, // Menggunakan ikon rounded
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded, // Ikon rounded
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- Tombol Login ---
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  darkNavy, // Warna tombol Login kini darkNavy
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18), // Padding lebih besar
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Sudut lebih membulat
                              ),
                              elevation: 5, // Tambah sedikit bayangan
                            ),
                            child: Text(
                              "LOGIN", // Teks kapital untuk penekanan
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget pembantu untuk Input Field yang modis ---
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Latar belakang transparan
        borderRadius: BorderRadius.circular(15), // Sudut lebih membulat
        border: Border.all(
            color: Colors.white.withOpacity(0.5)), // Border yang lebih halus
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 16), // Gaya teks input
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70, size: 22),
          hintText: hintText,
          hintStyle:
              GoogleFonts.poppins(color: Colors.white54), // Gaya teks hint
          border: InputBorder.none, // Hilangkan border bawaan
          contentPadding: const EdgeInsets.symmetric(
              vertical: 18, horizontal: 20), // Padding yang pas
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
