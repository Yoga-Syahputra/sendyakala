import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String advice = "Loading...";
  double progress = 0.0; // Current progress, ranges from 0.0 to 1.0

  @override
  void initState() {
    super.initState();
    fetchDailyAdvice();
  }

  fetchDailyAdvice() async {
    const apiKey = 'your_api_key'; // Replace with your actual API key
    final response = await http.get(Uri.parse('https://zenquotes.io/api/today/$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty && responseData[0] != null) {
        setState(() {
          advice = responseData[0]['q']; // Assuming 'q' is the field for the quote
        });
      } else {
        setState(() {
          advice = "No advice available";
        });
      }
    } else {
      setState(() {
        advice = "Failed to load advice";
      });
    }

    // Simulate progress update based on some criteria (e.g., length of advice)
    updateProgress();
  }

  // Example method to update progress based on criteria
  void updateProgress() {
    // Example: Calculate progress based on the length of advice
    int adviceLength = advice.length;
    progress = adviceLength / 100; // Assuming 100 characters goal for simplicity
    if (progress > 1.0) {
      progress = 1.0; // Cap progress to 100%
    }
    setState(() {
      progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Advice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.deepPurple[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(
                advice,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.deepPurple,
                  fontFamily: 'Georgia',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daily Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Placeholder for the progress wheel
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
