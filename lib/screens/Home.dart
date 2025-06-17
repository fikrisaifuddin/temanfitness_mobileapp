import 'dart:async';
import 'package:teman_fitness/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:teman_fitness/model/WorkoutModel.dart';
import 'package:teman_fitness/model/MentorModel.dart';
import 'package:teman_fitness/model/BannerModel.dart';
import 'package:teman_fitness/model/KelasModel.dart';
import 'package:teman_fitness/detail/detail_workout.dart';
import 'package:teman_fitness/detail/detail_mentor.dart';
import 'package:teman_fitness/detail/detail_kelas.dart';
import 'package:google_fonts/google_fonts.dart';

const Color darkBluePrimary = Color.fromARGB(255, 0, 7, 65);
const Color lightBlueAccent = Color.fromARGB(255, 171, 213, 255);
const Color whiteText70 = Colors.white70;
const Color whiteText = Colors.white;
const Color darkNavyCustom = Color(0xFF0D1B2A);

const Color lightBackground = Color(0xFFF0F4F8);
const Color darkText = Color(0xFF2C3E50);
const Color mediumText = Color(0xFF5E6B7E);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late Future<List<BannerModel>> _bannerFuture;

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<WorkoutModel> _allWorkout = [];
  List<MentorModel> _allMentor = [];
  List<KelasModel> _allKelas = [];

  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  int _bannerLength = 0;

  @override
  void initState() {
    super.initState();
    _bannerFuture = BannerModel.fetchBanner();
    _fetchData();

    _pageController = PageController(initialPage: 0);

    _bannerFuture.then((bannerList) {
      _bannerLength = bannerList.length;

      if (_bannerLength > 0) {
        _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
          if (_currentPage < _bannerLength - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  Future<void> _fetchData() async {
    try {
      final workout = await WorkoutModel.fetchWorkout();
      final mentor = await MentorModel.fetchMentor();
      final kelas = await KelasModel.fetchkelas();

      setState(() {
        _allWorkout = workout;
        _allMentor = mentor;
        _allKelas = kelas;
      });
    } catch (e) {
      print('Error fetching data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to load data. Please try again later.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkout = _searchQuery.isEmpty
        ? _allWorkout
        : _allWorkout
            .where((workout) =>
                workout.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    final filteredMentor = _searchQuery.isEmpty
        ? _allMentor
        : _allMentor
            .where((mentor) =>
                mentor.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    final filteredKelas = _searchQuery.isEmpty
        ? _allKelas
        : _allKelas
            .where((kelas) => kelas.namaKelas
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: (_allWorkout.isEmpty &&
                _allMentor.isEmpty &&
                _allKelas.isEmpty &&
                _searchQuery.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBanner(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: _searchController,
                        style:
                            GoogleFonts.poppins(fontSize: 16, color: darkText),
                        decoration: InputDecoration(
                          hintText: 'Cari workout, mentor, atau kelas...',
                          hintStyle:
                              GoogleFonts.poppins(color: Colors.grey[500]),
                          prefixIcon: Icon(Icons.search, color: mediumText),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color(0xFF001F3F).withOpacity(0.5),
                                width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color(0xFF001F3F), width: 2.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (filteredWorkout.isNotEmpty)
                      _buildSection(
                          "Workout Mandiri",
                          "Ga perlu ragu untuk olahraga mandiri.",
                          filteredWorkout,
                          (item) => DetailWorkout(workout: item),
                          (item) => "${AppConfig.baseUrl}/storage/${item.gif}",
                          (item) => item.name,
                          (item) => item.description,
                          icon: Icons.fitness_center),
                    if (filteredMentor.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: _buildSection(
                            "Para Mentor Kelas",
                            "Temukan mentor terbaik yang sesuai dengan kebutuhan Anda.",
                            filteredMentor,
                            (item) => DetailMentor(mentor: item),
                            (item) =>
                                "${AppConfig.baseUrl}/storage/${item.photo}",
                            (item) => item.name,
                            (item) => item.expertise,
                            icon: Icons.person_outline),
                      ),
                    if (filteredKelas.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: _buildSection(
                            "Kelas Bersama Mentor",
                            "Gabung kelas interaktif untuk pengalaman belajar yang lebih baik.",
                            filteredKelas,
                            (item) => DetailKelas(kelas: item),
                            (item) =>
                                "${AppConfig.baseUrl}/storage/${item.foto}",
                            (item) => item.namaKelas,
                            (item) => item.deskripsi,
                            icon: Icons.group_work_outlined),
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBanner() {
    return FutureBuilder<List<BannerModel>>(
      future: _bannerFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : Text(
                      'Tidak ada banner tersedia',
                      style: GoogleFonts.poppins(color: mediumText),
                    ),
            ),
          );
        }

        final banners = snapshot.data!;
        _bannerLength = banners.length;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return ClipRRect(
                    child: Stack(
                      children: [
                        Image.network(
                          "${AppConfig.baseUrl}/storage/${banner.gambar}",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Icon(Icons.broken_image,
                                color: Colors.grey[600], size: 50),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.judul,
                                style: GoogleFonts.poppins(
                                  color: whiteText,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8.0,
                                      color: Colors.black.withOpacity(0.6),
                                      offset: const Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                banner.deskripsi,
                                style: GoogleFonts.poppins(
                                  color: whiteText70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6.0,
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(1.5, 1.5),
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(banners.length, (index) {
                  return Container(
                    width: _currentPage == index ? 24.0 : 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? lightBlueAccent
                          : whiteText.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection<T>(
      String title,
      String subtitle,
      List<T> dataList,
      Widget Function(T) detailBuilder,
      String Function(T) imageUrlBuilder,
      String Function(T) nameBuilder,
      String Function(T) descriptionBuilder,
      {IconData? icon}) {
    if (dataList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, size: 28, color: darkBluePrimary),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(fontSize: 14, color: mediumText),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final item = dataList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detailBuilder(item),
                      ),
                    );
                  },
                  child: Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18)),
                          child: Image.network(
                            imageUrlBuilder(item),
                            height: 110,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 110,
                              width: double.infinity,
                              color: Colors.grey[300],
                              alignment: Alignment.center,
                              child: Icon(Icons.broken_image,
                                  color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nameBuilder(item),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: darkText),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  descriptionBuilder(item),
                                  style: GoogleFonts.poppins(
                                      fontSize: 11, color: mediumText),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Detail >',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: lightBlueAccent,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
