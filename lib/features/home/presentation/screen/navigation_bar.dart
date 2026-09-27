import 'package:flutter/material.dart';
import 'package:ride_way_app/features/map/presentation/map_screen.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/screens/search_screen.dart';
import 'package:ride_way_app/features/ticket/presentation/ticket_screen.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final List<Widget> screens = [
    const SearchScreen(), // Main Home Surface & Search
    const SearchScreen(),
    const TicketScreen(),
    const MapScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF181818),
        unselectedItemColor: const Color(0xFF8E8E93),
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            activeIcon: Icon(Icons.confirmation_number),
            label: "Ticket",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: "Map"),
        ],
      ),
    );
  }
}
