import 'package:fitnes_ptnit/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:fitnes_ptnit/model/KelasModel.dart';
import 'package:fitnes_ptnit/detail/detail_kelas.dart';
import 'package:google_fonts/google_fonts.dart'; 


const Color darkBluePrimary =
    Color.fromARGB(255, 0, 7, 65); 
const Color lightBlueAccent =
    Color.fromARGB(255, 171, 213, 255); 
const Color whiteText70 = Colors.white70;
const Color whiteText = Colors.white; 
const Color darkNavyCustom = Color(
    0xFF0D1B2A); 

const Color lightBackground =
    Color(0xFFF0F4F8); 
const Color textColorDark =
    Color(0xFF2C3E50); 
const Color textColorMedium =
    Color(0xFF5E6B7E); 
const Color dividerColor = Color(0xFFE0E0E0); 

class KelasScreen extends StatefulWidget {
  @override
  _KelasScreenState createState() => _KelasScreenState();
}

class _KelasScreenState extends State<KelasScreen> {
  late Future<List<KelasModel>> _kelasFuture;

  @override
  void initState() {
    super.initState();
    _kelasFuture = KelasModel.fetchkelas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          'Daftar Kelas', 
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textColorDark, 
          ),
        ),
        centerTitle: true, 
        leading: IconButton(
         
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: darkBluePrimary), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      backgroundColor: lightBackground, 
      body: FutureBuilder<List<KelasModel>>(
        future: _kelasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: darkBluePrimary)); 
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
                      'Gagal memuat data kelas: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: textColorMedium),
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
                      size: 60, color: textColorMedium),
                  const SizedBox(height: 10),
                  Text(
                    'Tidak ada data kelas tersedia.',
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: textColorMedium),
                  ),
                ],
              ),
            );
          }

          final kelasList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 20), 
            itemCount: kelasList.length,
            itemBuilder: (context, index) {
              final kelas = kelasList[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailKelas(kelas: kelas),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      bottom: 16), 
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20), 
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
                    padding: const EdgeInsets.all(
                        16), 
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, 
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              15),
                          child: Image.network(
                            "${AppConfig.baseUrl}/storage/${kelas.foto}",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              double? progressValue;
                              if (loadingProgress.expectedTotalBytes != null) {
                                progressValue =
                                    loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!;
                              }
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors
                                    .grey[200], 
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: darkBluePrimary.withOpacity(
                                        0.7), 
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
                                  color: textColorMedium, size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kelas.namaKelas,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18, 
                                  color: textColorDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8), 
                              Text(
                                kelas.deskripsi, 
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: textColorMedium,
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
        },
      ),
    );
  }
}
