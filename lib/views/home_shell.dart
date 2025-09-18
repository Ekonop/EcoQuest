import 'package:flutter/material.dart';
import 'package:eco_quest/views/dashboard_view.dart';
import 'package:eco_quest/views/modules_view.dart';
import 'package:eco_quest/views/leaderboard_view.dart';
import 'package:eco_quest/views/profile_view.dart';
import 'package:eco_quest/repositories/local_storage_service.dart';

class HomeShell extends StatefulWidget {
  static const routeName = '/home';
  final int initialIndex;
  const HomeShell({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with TickerProviderStateMixin {
  late int _currentIndex;
  late LocalStorageService _storage;
  bool _loading = true;

  final _pages = const [
    DashboardView(),
    ModulesView(),
    LeaderboardView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
  _storage = LocalStorageService();
  _currentIndex = widget.initialIndex;
  _init();
  }

  Future<void> _init() async {
    final last = await _storage.getLastSelectedTab();
    if (mounted) {
      setState(() {
        _currentIndex = last;
        _loading = false;
      });
    }
  }

  Future<void> _onTabChanged(int i) async {
    setState(() => _currentIndex = i);
    await _storage.setLastSelectedTab(i);
  }

  void _openFabMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.forest, color: Colors.green),
                title: const Text('New Challenge'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to create challenge flow
                },
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                title: const Text('Scan Eco Action'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Launch scan flow
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutQuad,
        switchOutCurve: Curves.easeInQuad,
        child: IndexedStack(
          key: ValueKey(_currentIndex),
          index: _currentIndex,
          children: _pages,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openFabMenu,
        icon: const Icon(Icons.add_task),
        label: const Text('Action'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabChanged,
        height: 70,
        destinations: [
          _navDestination(Icons.home, 'Home', 0),
          _navDestination(Icons.book, 'Modules', 1, badgeCount: 2),
          _navDestination(Icons.leaderboard, 'Rank', 2),
          _navDestination(Icons.person, 'Profile', 3, showDot: true),
        ],
      ),
    );
  }

  NavigationDestination _navDestination(IconData icon, String label, int index,{int? badgeCount,bool showDot=false}) {
    final bool selected = _currentIndex == index;
    Widget displayedIcon = Icon(icon, color: selected ? Colors.green : null);
    if (badgeCount != null && badgeCount > 0) {
      displayedIcon = Stack(
        clipBehavior: Clip.none,
        children: [
          displayedIcon,
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10,fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      );
    } else if (showDot) {
      displayedIcon = Stack(
        clipBehavior: Clip.none,
        children: [
          displayedIcon,
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      );
    }
    return NavigationDestination(
      icon: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: selected ? 1.15 : 1.0,
        child: displayedIcon,
      ),
      label: label,
    );
  }
}
