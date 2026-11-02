import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ride_way_app/core/themes/theme_data.dart';
import 'package:ride_way_app/features/account/presentation/screens/profile_screen.dart';
import 'package:ride_way_app/features/notfication/presentation/notfication_screen.dart';
import 'package:ride_way_app/features/search_and_discovery/presentation/screens/search_screen.dart';
import 'package:ride_way_app/features/tickets/presentation/pages/history_tickets_page.dart';
import 'package:ride_way_app/features/trips/presentation/screens/my_bookings_screen.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  final List<Widget> screens = [
    const SearchScreen(),

    const MyBookingsScreen(),
    const NotficationScreen(),
    const ProfileScreen(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
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
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: tr('homenav', context: context),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_number_outlined),
                activeIcon: Icon(Icons.confirmation_number),
                label: tr('ticketsnav', context: context),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: tr('notificationsnav', context: context),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: tr('profilenav', context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
