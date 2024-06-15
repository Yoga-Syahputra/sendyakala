import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ReflectionJournalScreen extends StatefulWidget {
  const ReflectionJournalScreen({Key? key}) : super(key: key);

  @override
  _ReflectionJournalScreenState createState() => _ReflectionJournalScreenState();
}

class _ReflectionJournalScreenState extends State<ReflectionJournalScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Reflection> reflections = []; // List to store reflections
  static const maxReflections = 10; // Maximum number of reflections to display

  @override
  void initState() {
    super.initState();
    _loadReflections();
  }

  _loadReflections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      reflections = (prefs.getStringList('reflections') ?? [])
          .map((reflection) => Reflection.fromMap(jsonDecode(reflection)))
          .toList();
      _controller.text = ''; // Clear input field after loading reflections
    });
  }

  _saveReflection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Add new reflection to the list
    reflections.insert(0, Reflection(_controller.text));
    // Limit reflections to maxReflections
    if (reflections.length > maxReflections) {
      reflections.removeLast();
    }
    prefs.setStringList('reflections', reflections.map((reflection) => jsonEncode(reflection.toMap())).toList());
    setState(() {
      _controller.text = ''; // Clear input field after saving reflection
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved')),
    );
  }

  _showReflectionDetails(Reflection reflection) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reflection Details'),
          content: Text('Reflection: ${reflection.text}\n\nAdded on: ${reflection.timestamp}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection Journal'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Write your reflection here",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _saveReflection,
            child: const Text('Save Reflection'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Reflections',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reflections.length,
              itemBuilder: (BuildContext context, int index) {
                final reflection = reflections[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () => _showReflectionDetails(reflection),
                    child: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reflection.text,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Added on: ${reflection.timestamp}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Reflection {
  final String text;
  final String timestamp;

  Reflection(this.text) : timestamp = DateTime.now().toString();

  Reflection.fromMap(Map<String, dynamic> map)
      : text = map['text'],
        timestamp = map['timestamp'];

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp,
    };
  }
}
