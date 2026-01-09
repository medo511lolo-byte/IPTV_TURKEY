import 'package:flutter/material.dart';
import '../services/epg_service.dart';
import 'player.dart';

class EPGScreen extends StatelessWidget {
  final String server, user, pass, streamId;
  final String channelName;
  final bool supportsCatchup;
  final int archiveDays;

  const EPGScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
    required this.streamId,
    this.channelName = 'EPG',
    this.supportsCatchup = false,
    this.archiveDays = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(channelName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Info banner
          if (supportsCatchup)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.green.shade100,
              child: Row(
                children: [
                  const Icon(Icons.history, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Catch-Up available: $archiveDays days',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // EPG List
          Expanded(
            child: FutureBuilder(
              future: EPGService.getEPG(server, user, pass, streamId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'EPG not available for this channel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 60, color: Colors.grey),
                        SizedBox(height: 20),
                        Text(
                          'No EPG data available',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final epgList = snapshot.data as List<Map<String, dynamic>>;

                return ListView.builder(
                  itemCount: epgList.length,
                  itemBuilder: (_, i) {
                    final epg = epgList[i];
                    final title = epg['title'] ?? 'No Title';
                    final description = epg['description'] ?? '';
                    final startTime = epg['start'] as DateTime?;
                    final stopTime = epg['stop'] as DateTime?;

                    final isLive = EPGService.isLiveNow(startTime, stopTime);
                    final isPast = EPGService.isPast(stopTime);
                    final canCatchup = supportsCatchup && isPast;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: isLive ? Colors.blue.shade50 : null,
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isLive
                                  ? Icons.fiber_manual_record
                                  : (isPast ? Icons.history : Icons.schedule),
                              color: isLive
                                  ? Colors.red
                                  : (isPast ? Colors.grey : Colors.blue),
                            ),
                            if (isLive)
                              const Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight:
                                isLive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${EPGService.formatTimeOnly(startTime)} - ${EPGService.formatTimeOnly(stopTime)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (description.isNotEmpty)
                              Text(
                                description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        trailing: canCatchup
                            ? IconButton(
                                icon: const Icon(Icons.play_circle_fill),
                                color: Colors.green,
                                onPressed: () {
                                  if (startTime != null) {
                                    final catchupUrl = EPGService.getCatchUpUrl(
                                      server,
                                      user,
                                      pass,
                                      streamId,
                                      startTime,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PlayerScreen(
                                          url: catchupUrl,
                                          channelName: '$title (Catch-Up)',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            : null,
                        onTap: isLive
                            ? () {
                                final liveUrl =
                                    "$server/live/$user/$pass/$streamId.ts";
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlayerScreen(
                                      url: liveUrl,
                                      channelName: '$title (Live)',
                                    ),
                                  ),
                                );
                              }
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
