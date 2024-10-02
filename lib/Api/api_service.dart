import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_app/model/user_model.dart';

class ApiService {
  static const String apiUrl = 'https://ixifly.in/flutter/task2';

  Future<List<UserModel>> fetchStories() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data') && responseData['data'] is List) {
        List<dynamic> dataList = responseData['data'];
        return dataList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load stories');
    }
  }
}
