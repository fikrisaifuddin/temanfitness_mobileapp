import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teman_fitness/screens/Login.dart';
import 'package:teman_fitness/screens/Workout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

const Color darkBluePrimary = Color.fromARGB(255, 0, 7, 65);
const Color lightBlueAccent = Color.fromARGB(255, 171, 213, 255);
const Color whiteText70 = Colors.white70;
const Color whiteText = Colors.white;
const Color darkNavyCustom = Color(0xFF0D1B2A);

const Color lightBackground = Color(0xFFF0F4F8);
const Color textColorDark = Color(0xFF2C3E50);
const Color textColorMedium = Color(0xFF5E6B7E);
const Color dividerColor = Color(0xFFE0E0E0);

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> sosialMedia = [
    {
      'name': 'YouTube',
      'icon': Icons.play_circle_fill_rounded,
      'color': Colors.red[700], // Keep original for brand recognition
      'url': 'https://www.youtube.com/@FlutterDevOfficial'
    },
    {
      'name': 'Facebook',
      'icon': Icons.facebook_rounded,
      'color': Colors.blue[800], // Keep original for brand recognition
      'url': 'https://www.facebook.com/FlutterDev'
    },
    {
      'name': 'Instagram',
      'icon': Icons.camera_alt_rounded,
      'color': Colors.purple[700], // Keep original for brand recognition
      'url': 'https://www.instagram.com/flutter.dev/'
    },
  ];

  Future<Map<String, dynamic>> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email') ?? 'email@example.com';
    String name = prefs.getString('user_name') ?? 'Nama Pengguna';
    String phone = prefs.getString('user_phone') ?? '+62 812-3456-7890';
    String status = prefs.getString('user_status') ?? 'non_active';

    return {
      'email': email,
      'name': name,
      'phone': phone,
      'membershipStatus': status,
    };
  }

  Future<void> _confirmLogout() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Konfirmasi Logout',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: textColorDark),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: GoogleFonts.poppins(color: textColorMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                  color: darkBluePrimary), 
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                  255, 255, 4, 4), 
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget _membershipStatusWidget(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'active':
        color = Colors.green[600]!;
        label = 'Aktif';
        icon = Icons.check_circle_rounded;
        break;
      case 'expired':
        color = lightBlueAccent;
        label = 'Kadaluarsa';
        icon = Icons.error_rounded;
        break;
      default:
        color = textColorMedium;
        label = 'Tidak Aktif';
        icon = Icons.cancel_rounded;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak dapat membuka $url',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: darkBluePrimary, // SnackBar using darkBluePrimary
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    IconData? leadingIcon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 10.0, top: 10.0),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: iconColor ?? textColorDark, size: 22),
                const SizedBox(width: 10),
              ],
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColorDark,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: darkBluePrimary));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: textColorMedium),
                    const SizedBox(height: 10),
                    Text(
                      'Terjadi kesalahan saat memuat data: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: textColorMedium),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied_rounded,
                      size: 60, color: textColorMedium),
                  const SizedBox(height: 10),
                  Text(
                    'Data pengguna tidak tersedia.',
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: textColorMedium),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [darkBluePrimary, lightBlueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionCard(
                            title: 'Informasi Profil',
                            leadingIcon: Icons.info_outline_rounded,
                            iconColor: darkBluePrimary, // Using darkBluePrimary
                            children: [
                              ListTile(
                                leading: const Icon(Icons.verified_user_rounded,
                                    color: textColorMedium),
                                title: Text(
                                  'Status Membership',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: textColorDark),
                                ),
                                trailing: _membershipStatusWidget(
                                    data['membershipStatus']),
                              ),
                              const Divider(
                                  indent: 16,
                                  endIndent: 16,
                                  height: 1,
                                  color: dividerColor),
                              ListTile(
                                leading: const Icon(Icons.email_rounded,
                                    color: textColorMedium),
                                title: Text(
                                  'Email',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: textColorDark),
                                ),
                                subtitle: Text(
                                  data['email'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: textColorMedium),
                                ),
                              ),
                              const Divider(
                                  indent: 16,
                                  endIndent: 16,
                                  height: 1,
                                  color: dividerColor),
                              ListTile(
                                leading: const Icon(Icons.phone_rounded,
                                    color: textColorMedium),
                                title: Text(
                                  'Nomor Telepon',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: textColorDark),
                                ),
                                subtitle: Text(
                                  data['phone'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: textColorMedium),
                                ),
                              ),
                            ],
                          ),

                          _buildSectionCard(
                            title: 'Instruksi',
                            leadingIcon: Icons.assignment_rounded,
                            iconColor: darkBluePrimary,
                            children: [
                              ListTile(
                                leading: const Icon(
                                    Icons.fitness_center_rounded,
                                    color: darkBluePrimary),
                                title: Text(
                                  'Lihat Daftar Workout Saya',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: textColorDark),
                                ),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: textColorMedium),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WorkoutScreen()),
                                  );
                                },
                              ),
                            ],
                          ),

                          _buildSectionCard(
                            title: 'Ikuti Kami',
                            leadingIcon: Icons.people_alt_rounded,
                            iconColor: darkBluePrimary,
                            children: List.generate(
                              sosialMedia.length,
                              (index) => Column(
                                children: [
                                  ListTile(
                                    leading: Icon(sosialMedia[index]['icon'],
                                        color: sosialMedia[index]['color']),
                                    title: Text(
                                      sosialMedia[index]['name'],
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: textColorDark),
                                    ),
                                    trailing: const Icon(
                                        Icons.open_in_new_rounded,
                                        size: 18,
                                        color: textColorMedium),
                                    onTap: () {
                                      _launchUrl(sosialMedia[index]['url']);
                                    },
                                  ),
                                  if (index < sosialMedia.length - 1)
                                    const Divider(
                                        indent: 16,
                                        endIndent: 16,
                                        height: 1,
                                        color: dividerColor),
                                ],
                              ),
                            ),
                          ),

                          // --- Tombol Logout ---
                          _buildSectionCard(
                            title: '',
                            children: [
                              ListTile(
                                leading: const Icon(Icons.logout_rounded,
                                    color: darkBluePrimary),
                                title: Text(
                                  'Logout',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: darkBluePrimary),
                                ),
                                onTap: _confirmLogout,
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
