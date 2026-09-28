import 'package:flutter/material.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/account/presentation/screens/profile_screen.dart';
import 'package:ride_way_app/features/map/presentation/map_screen.dart';
import 'package:ride_way_app/features/notfication/presentation/notfication_screen.dart';
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

    const TicketScreen(),
    const NotficationScreen(),
    const ProfileScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: kColorAccentGold, width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: currentIndex,
            selectedItemColor: kColorAccentGold,
            unselectedItemColor: kColorSubtitle,
            onTap: (index) => setState(() {
              currentIndex = index;
            }),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number_outlined),
                label: "My Tickets",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.confirmation_number),
                label: "Notification",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                activeIcon: Icon(Icons.map),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
