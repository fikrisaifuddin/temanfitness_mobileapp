import 'dart:convert';
import 'package:fitnes_ptnit/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BannerModel {
  final String id;
  final String judul;
  final String gambar;
  final String deskripsi;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerModel({
    required this.id,
    required this.judul,
    required this.gambar,
    required this.deskripsi,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      gambar: json['gambar'],
      deskripsi: json['deskripsi'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static Future<List<BannerModel>> fetchBanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token belum tersedia, user belum login');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/banners'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load banner data');
    }
  }
}
