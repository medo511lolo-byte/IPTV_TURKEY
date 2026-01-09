import 'dart:convert';
import 'package:http/http.dart' as http;

class VodAPI {
  static Future<List<dynamic>> getMovies(
    String server,
    String user,
    String pass,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_vod_streams";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> getMovieCategories(
    String server,
    String user,
    String pass,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_vod_categories";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load movie categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> getSeries(
    String server,
    String user,
    String pass,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_series";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load series');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> getSeriesCategories(
    String server,
    String user,
    String pass,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_series_categories";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        throw Exception('Failed to load series categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<dynamic>> getEpisodes(
    String server,
    String user,
    String pass,
    String seriesId,
  ) async {
    final url = "$server/player_api.php?username=$user&password=$pass&action=get_series_info&series_id=$seriesId";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        
        // معالجة الحلقات من الاستجابة
        if (data is Map && data['episodes'] != null) {
          final episodes = <Map<String, dynamic>>[];
          final episodesData = data['episodes'];
          
          if (episodesData is Map) {
            // كل موسم عبارة عن قائمة من الحلقات
            episodesData.forEach((season, seasonEpisodes) {
              if (seasonEpisodes is List) {
                for (var episode in seasonEpisodes) {
                  if (episode is Map) {
                    episodes.add({
                      ...episode,
                      'season': season,
                    });
                  }
                }
              }
            });
          }
          
          return episodes;
        }
        
        return [];
      } else {
        throw Exception('Failed to load episodes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
