import 'package:flutter/material.dart';
import 'live_tv.dart';
import 'movies.dart';
import 'series.dart';

class HomeScreen extends StatelessWidget {
  final String server, user, pass;

  const HomeScreen({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.live_tv,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 50),
              
              // Live TV Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.live_tv, size: 30),
                  label: const Text(
                    "Live TV",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveTVScreen(
                          server: server,
                          user: user,
                          pass: pass,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Movies Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.movie, size: 30),
                  label: const Text(
                    "Movies",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoviesScreen(
                          server: server,
                          user: user,
                          pass: pass,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Series Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.tv, size: 30),
                  label: const Text(
                    "Series",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeriesScreen(
                          server: server,
                          user: user,
                          pass: pass,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
