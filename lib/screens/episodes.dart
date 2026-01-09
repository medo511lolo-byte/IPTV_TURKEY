import 'package:flutter/material.dart';
import '../services/vod_api.dart';
import 'player.dart';

class EpisodesScreen extends StatelessWidget {
  final String server, user, pass, seriesId;
  final String seriesName;

  const EpisodesScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
    required this.seriesId,
    this.seriesName = 'Episodes',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(seriesName),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: VodAPI.getEpisodes(server, user, pass, seriesId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No episodes available"));
          }

          final episodes = snapshot.data as List;

          return ListView.builder(
            itemCount: episodes.length,
            itemBuilder: (_, i) {
              final e = episodes[i];
              final season = e['season'] ?? '?';
              final episodeNum = e['episode_num'] ?? '?';
              final title = e['title'] ?? 'Episode $episodeNum';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      'S$season',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    'Episode $episodeNum',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.play_circle_fill),
                  onTap: () {
                    final url = "$server/series/$user/$pass/${e['id']}.${e['container_extension']}";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerScreen(
                          url: url,
                          channelName: 'S$season E$episodeNum - $title',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
