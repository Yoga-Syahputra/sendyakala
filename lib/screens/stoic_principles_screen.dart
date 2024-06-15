import 'package:flutter/material.dart';

class StoicPrinciplesScreen extends StatelessWidget {
  const StoicPrinciplesScreen({Key? key}) : super(key: key);

  final List<String> principles = const [
    "Live in agreement with nature",
    "Focus on what you can control",
    "Accept fate and practice amor fati",
    "Practice mindfulness and self-awareness",
    "Cultivate wisdom, courage, justice, and temperance"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: principles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            principles[index],
            style: const TextStyle(
              fontSize: 18,
              color: Colors.deepPurple,
              fontFamily: 'Georgia',
            ),
          ),
        );
      },
    );
  }
}
