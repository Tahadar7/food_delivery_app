import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoPageBloc with ChangeNotifier {
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> get searchResults => _searchResults;
  String _query = "Food Reviews";
  String get query => _query;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchVideos(String queryTerm) async {
    _isLoading = true;
    notifyListeners();

    String apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&q=$queryTerm&type=video&part=snippet&maxResults=10';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        _searchResults = items.map((video) {
          return {
            'id': video['id']['videoId'],
            'title': video['snippet']['title'],
            'thumbnail': video['snippet']['thumbnails']['high']['url'],
            'channel': video['snippet']['channelTitle'],
          };
        }).toList();
      } else {
        debugPrint('YouTube API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception during video search: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }
}
