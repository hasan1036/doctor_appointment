import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/doctor_model.dart';

class DoctorService {
  static const String apiUrl =
      'https://medicalbd-001-site1.etempurl.com/api/Doctors/GetAllDoctors?currentPage=1&itemsPerPage=10';

  static const String username = '11333566';
  static const String password = '60-dayfreetrial';

  static Future<List<Doctor>> getDoctors() async {
    try {
      // Basic Authentication
      final String basicAuth =
          'Basic ${base64Encode(
        utf8.encode('$username:$password'),
      )}';

      final Uri url = Uri.parse(apiUrl);

      print('Doctor API URL: $url');

      final http.Response response =
      await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': basicAuth,
        },
      );

      print(
        'Doctor API Status: ${response.statusCode}',
      );

      print(
        'Doctor API Response: ${response.body}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
        jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        final List<Doctor> doctors =
        data
            .map(
              (item) =>
              Doctor.fromJson(
                Map<String, dynamic>.from(
                  item,
                ),
              ),
        )
            .toList();

        print(
          'Total Doctors: ${doctors.length}',
        );

        return doctors;
      } else {
        throw Exception(
          'API Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Doctor API ERROR: $e');

      rethrow;
    }
  }
}