import 'package:flutter/material.dart';
import 'package:sendyakala/screens/home_page.dart';
import 'package:sendyakala/screens/stoic_principles_screen.dart';
import 'package:sendyakala/screens/reflection_journal_screen.dart';
import 'package:sendyakala/screens/meditation_timer_screen.dart';
import 'package:sendyakala/screens/senbot_screen.dart'; // Import SenBotScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),  // HomePage as the first screen
    const StoicPrinciplesScreen(),
    const ReflectionJournalScreen(),
    const MeditationTimerScreen(),
    const SenBotScreen(), // Add SenBotScreen to the list
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Advice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Principles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat), // Add chat icon
            label: 'SenBot', // Label for SenBot
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
