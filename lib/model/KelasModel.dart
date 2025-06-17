import 'package:teman_fitness/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MentorModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KelasModel {
  final int id;
  final String namaKelas;
  final String deskripsi;
  final String foto;
  final DateTime jadwalKelas;
  final int mentorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MentorModel mentor;

  KelasModel({
    required this.id,
    required this.namaKelas,
    required this.deskripsi,
    required this.foto,
    required this.jadwalKelas,
    required this.mentorId,
    required this.createdAt,
    required this.updatedAt,
    required this.mentor,
  });

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: json['id'],
      namaKelas: json['nama_kelas'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      jadwalKelas: DateTime.parse(json['jadwal_kelas']),
      mentorId: json['mentor_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      mentor: MentorModel.fromJson(json['mentor']),
    );
  }

  static Future<List<KelasModel>> fetchkelas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token belum tersedia, user belum login');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/kelas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 10));
    // final response =
    // await http.get(Uri.parse('http://127.0.0.1:8000/api/kelas'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((json) => KelasModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load mentor data');
    }
  }
}
