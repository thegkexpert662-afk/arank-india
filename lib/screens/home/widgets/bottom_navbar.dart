import 'package:flutter/material.dart';
import 'package:arank_india/screens/profile/profile_screen.dart';
import 'package:arank_india/screens/practice/practice_screen.dart';
import 'package:arank_india/screens/mock_test/mock_test_list_screen.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedItemColor: const Color(0xFF2962FF),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: "Practice",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: "Tests",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: "Profile",
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
          //Home
            break;

          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PracticeScreen(),
              ),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MockTestListScreen(),
              ),
            );
            break;

          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
            break;
        }
      },
    );
  }
}