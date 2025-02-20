import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pagination/project_model.dart';


class ProjectService {  
  String baseUrl = 'YOUR_API_ENDPOINT_HERE';
  Future<ProjectModel> getProjects({int page = 1, int perPage = 6}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/projects?page=$page&per_page=$perPage'),
        headers: {
          'Content-Type': 'application/json',
          // Add any required headers
        },
      );

      if (response.statusCode == 200) {
        return ProjectModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load projects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching projects: $e');
    }
  }


}


