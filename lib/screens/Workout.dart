import 'package:teman_fitness/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:teman_fitness/model/WorkoutModel.dart';
import 'package:teman_fitness/detail/detail_workout.dart';
import 'package:google_fonts/google_fonts.dart';

const Color darkBluePrimary = Color.fromARGB(255, 0, 7, 65);
const Color lightBlueAccent = Color.fromARGB(255, 171, 213, 255);
const Color whiteText70 = Colors.white70;
const Color whiteText = Colors.white;
const Color darkNavyCustom = Color(0xFF0D1B2A);

const Color lightBackground = Color(0xFFF0F4F8);
const Color darkText = Color(0xFF2C3E50);
const Color mediumText = Color(0xFF5E6B7E);

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Workout',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: darkBluePrimary,
          ),
        ),
      ),
      backgroundColor: lightBackground,
      body: FutureBuilder<List<WorkoutModel>>(
        future: WorkoutModel.fetchWorkout(),
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
                    Icon(Icons.error_outline, size: 60, color: mediumText),
                    const SizedBox(height: 10),
                    Text(
                      'Gagal memuat data: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: mediumText),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied_rounded,
                      size: 60, color: mediumText),
                  const SizedBox(height: 10),
                  Text(
                    'Tidak ada data workout tersedia.',
                    style: GoogleFonts.poppins(fontSize: 16, color: mediumText),
                  ),
                ],
              ),
            );
          } else {
            final workoutList = snapshot.data!;
            return ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              itemCount: workoutList.length,
              itemBuilder: (context, index) {
                final workout = workoutList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailWorkout(workout: workout),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              "${AppConfig.baseUrl}/storage/${workout.gif}",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                double? progressValue;
                                if (loadingProgress.expectedTotalBytes !=
                                    null) {
                                  progressValue =
                                      loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!;
                                }

                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: lightBlueAccent,
                                      value: progressValue,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                alignment: Alignment.center,
                                child: Icon(Icons.broken_image_rounded,
                                    color: mediumText, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: darkText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  workout.description,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: mediumText,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Lihat Detail >',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: lightBlueAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
