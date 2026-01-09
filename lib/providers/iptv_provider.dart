import 'package:flutter/material.dart';
import '../services/xtream_api.dart';
import '../services/vod_api.dart';
import '../services/cache_service.dart';

class IPTVProvider extends ChangeNotifier {
  Map<String, dynamic> liveData = {};
  Map<String, dynamic> moviesData = {};
  Map<String, dynamic> seriesData = {};

  bool isLoadingLive = false;
  bool isLoadingMovies = false;
  bool isLoadingSeries = false;

  /// LIVE TV
  Future<void> loadLive(String server, String user, String pass) async {
    if (liveData.isNotEmpty) return;

    final cached = await CacheService.load('live');
    if (cached != null) {
      liveData = cached;
      notifyListeners();
      return;
    }

    isLoadingLive = true;
    notifyListeners();

    try {
      final categories = await XtreamAPI.getLiveCategories(server, user, pass);
      final channels = await XtreamAPI.getLiveChannels(server, user, pass);
      
      liveData = {
        'categories': categories,
        'channels': channels,
      };
      
      await CacheService.save('live', liveData);
    } catch (e) {
      // تجاهل الأخطاء
    }

    isLoadingLive = false;
    notifyListeners();
  }

  /// MOVIES
  Future<void> loadMovies(String server, String user, String pass) async {
    if (moviesData.isNotEmpty) return;

    final cached = await CacheService.load('movies');
    if (cached != null) {
      moviesData = cached;
      notifyListeners();
      return;
    }

    isLoadingMovies = true;
    notifyListeners();

    try {
      final categories = await VodAPI.getMovieCategories(server, user, pass);
      final movies = await VodAPI.getMovies(server, user, pass);
      
      moviesData = {
        'categories': categories,
        'movies': movies,
      };
      
      await CacheService.save('movies', moviesData);
    } catch (e) {
      // تجاهل الأخطاء
    }

    isLoadingMovies = false;
    notifyListeners();
  }

  /// SERIES
  Future<void> loadSeries(String server, String user, String pass) async {
    if (seriesData.isNotEmpty) return;

    final cached = await CacheService.load('series');
    if (cached != null) {
      seriesData = cached;
      notifyListeners();
      return;
    }

    isLoadingSeries = true;
    notifyListeners();

    try {
      final categories = await VodAPI.getSeriesCategories(server, user, pass);
      final series = await VodAPI.getSeries(server, user, pass);
      
      seriesData = {
        'categories': categories,
        'series': series,
      };
      
      await CacheService.save('series', seriesData);
    } catch (e) {
      // تجاهل الأخطاء
    }

    isLoadingSeries = false;
    notifyListeners();
  }

  /// تحديث يدوي
  Future<void> refreshLive(String server, String user, String pass) async {
    liveData = {};
    await CacheService.save('live', {});
    await loadLive(server, user, pass);
  }

  Future<void> refreshMovies(String server, String user, String pass) async {
    moviesData = {};
    await CacheService.save('movies', {});
    await loadMovies(server, user, pass);
  }

  Future<void> refreshSeries(String server, String user, String pass) async {
    seriesData = {};
    await CacheService.save('series', {});
    await loadSeries(server, user, pass);
  }

  Future<void> refreshAll(String server, String user, String pass) async {
    liveData = {};
    moviesData = {};
    seriesData = {};
    
    await CacheService.clear();
    
    await loadLive(server, user, pass);
    await loadMovies(server, user, pass);
    await loadSeries(server, user, pass);
  }
}
