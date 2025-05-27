import 'dart:convert';
import 'package:fitnes_ptnit/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class WorkoutModel {
  final int id;
  final String name;
  final String description;
  final String gif;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.description,
    required this.gif,
    required this.createdAt,
    required this.updatedAt,
  });
  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      gif: json['gif'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  static Future<List<WorkoutModel>> fetchWorkout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token belum tersedia, user belum login');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.baseUrl}/api/workouts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((json) => WorkoutModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load mentor data');
    }
  }
}
