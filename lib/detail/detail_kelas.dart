import 'package:fitnes_ptnit/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fitnes_ptnit/model/KelasModel.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; 

const Color darkBluePrimary =
    Color.fromARGB(255, 0, 7, 65); 
const Color lightBlueAccent =
    Color.fromARGB(255, 171, 213, 255); 
const Color pureWhite =
    Colors.white; 

const Color lightBackgroundBlue =
    Color(0xFFF0F4F8); 
const Color textColorDark =
    Color(0xFF2C3E50); 
const Color textColorMedium =
    Color(0xFF5E6B7E); 

class DetailKelas extends StatelessWidget {
  final KelasModel kelas;

  const DetailKelas({super.key, required this.kelas});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, dd MMMM yyyy – kk:mm',
            'id_ID') 
        .format(kelas.jadwalKelas);

    return Scaffold(
      backgroundColor:
          lightBackgroundBlue, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: darkBluePrimary), 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Kelas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColorDark, 
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kelas.namaKelas,
              style: GoogleFonts.poppins(
                fontSize: 26, 
                fontWeight: FontWeight.bold,
                color: darkBluePrimary, 
              ),
            ),
            const SizedBox(height: 16), 
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height:
                      250, 
                  width: double.infinity, 
                  decoration: BoxDecoration(
                    color: Colors.grey[200], 
                  ),
                  child: Image.network(
                    "${AppConfig.baseUrl}/storage/${kelas.foto}",
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color:
                              lightBlueAccent,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 60,
                          color:
                              textColorMedium,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24), 
            _buildInfoRow(
              context,
              label: 'Mentor',
              value: kelas.mentor.name,
              icon: Icons.person_rounded,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              label: 'Jadwal',
              value: formattedDate,
              icon: Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 24),
            Text(
              'Deskripsi Kelas:', 
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColorDark, 
              ),
            ),
            const SizedBox(height: 8), 
            Text(
              kelas.deskripsi,
              style: GoogleFonts.poppins(
                fontSize: 15,
                height: 1.5,
                color: textColorMedium, 
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required String label, required String value, required IconData icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            color: darkBluePrimary, size: 24), 
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColorDark, 
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: textColorMedium, 
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
