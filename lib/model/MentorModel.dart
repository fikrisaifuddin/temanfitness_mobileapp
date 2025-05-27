import 'dart:convert';
import 'package:fitnes_ptnit/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MentorModel {
  final int id;
  final String name;
  final String expertise;
  final String contact;
  final String photo;
  final DateTime createdAt;
  final DateTime updatedAt;

  MentorModel({
    required this.id,
    required this.name,
    required this.expertise,
    required this.contact,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'],
      name: json['name'],
      expertise: json['expertise'],
      contact: json['contact'],
      photo: json['photo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  static Future<List<MentorModel>> fetchMentor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token belum tersedia, user belum login');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/mentors'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((json) => MentorModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load mentor data');
    }
  }
}
