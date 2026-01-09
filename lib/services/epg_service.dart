import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class EPGService {
  static Future<List<Map<String, dynamic>>> getEPG(
    String server,
    String user,
    String pass,
    String streamId,
  ) async {
    try {
      final url = "$server/xmltv.php?username=$user&password=$pass";
      
      final res = await http.get(Uri.parse(url));
      
      if (res.statusCode != 200) {
        throw Exception('Failed to load EPG');
      }

      final document = XmlDocument.parse(res.body);
      final programmes = document.findAllElements('programme');

      List<Map<String, dynamic>> epgList = [];

      for (var p in programmes) {
        if (p.getAttribute('channel') == streamId) {
          final startStr = p.getAttribute('start') ?? '';
          final stopStr = p.getAttribute('stop') ?? '';
          
          // Parse XMLTV time format: YYYYMMDDHHmmss +0000
          DateTime? startTime = _parseXmlTvTime(startStr);
          DateTime? stopTime = _parseXmlTvTime(stopStr);

          String title = '';
          String description = '';
          
          final titleElement = p.findElements('title').firstOrNull;
          if (titleElement != null) {
            title = titleElement.innerText;
          }

          final descElement = p.findElements('desc').firstOrNull;
          if (descElement != null) {
            description = descElement.innerText;
          }

          epgList.add({
            'title': title,
            'description': description,
            'start': startTime,
            'stop': stopTime,
            'startStr': startStr,
            'stopStr': stopStr,
          });
        }
      }

      // Sort by start time
      epgList.sort((a, b) {
        if (a['start'] == null || b['start'] == null) return 0;
        return (a['start'] as DateTime).compareTo(b['start'] as DateTime);
      });

      return epgList;
    } catch (e) {
      throw Exception('Error loading EPG: $e');
    }
  }

  static DateTime? _parseXmlTvTime(String xmlTvTime) {
    try {
      if (xmlTvTime.isEmpty) return null;
      
      // Format: YYYYMMDDHHmmss +0000
      final dateStr = xmlTvTime.substring(0, 14);
      
      final year = int.parse(dateStr.substring(0, 4));
      final month = int.parse(dateStr.substring(4, 6));
      final day = int.parse(dateStr.substring(6, 8));
      final hour = int.parse(dateStr.substring(8, 10));
      final minute = int.parse(dateStr.substring(10, 12));
      final second = int.parse(dateStr.substring(12, 14));

      return DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      return null;
    }
  }

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('MMM dd, HH:mm').format(dateTime);
  }

  static String formatTimeOnly(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }

  static bool isLiveNow(DateTime? start, DateTime? stop) {
    if (start == null || stop == null) return false;
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(stop);
  }

  static bool isPast(DateTime? stop) {
    if (stop == null) return false;
    return DateTime.now().isAfter(stop);
  }

  static String getCatchUpUrl(
    String server,
    String user,
    String pass,
    String streamId,
    DateTime startTime,
  ) {
    final formattedDate = DateFormat('yyyy-MM-dd:HH-mm').format(startTime);
    return "$server/live/$user/$pass/$streamId.ts?start=$formattedDate";
  }
}
