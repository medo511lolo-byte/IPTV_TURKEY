import 'package:flutter/material.dart';
import '../theme.dart';
import 'live_tv.dart';
import 'movies.dart';
import 'series.dart';
import 'settings.dart';

class Dashboard extends StatefulWidget {
  final String server, user, pass;
  
  const Dashboard({
    super.key,
    required this.server,
    required this.user,
    required this.pass,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LiveTVScreen(
        server: widget.server,
        user: widget.user,
        pass: widget.pass,
      ),
      MoviesScreen(
        server: widget.server,
        user: widget.user,
        pass: widget.pass,
      ),
      SeriesScreen(
        server: widget.server,
        user: widget.user,
        pass: widget.pass,
      ),
      SettingsScreen(
        server: widget.server,
        user: widget.user,
        pass: widget.pass,
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _changePage,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: AppTheme.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              label: 'القنوات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'الأفلام',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.theaters),
              label: 'المسلسلات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}
