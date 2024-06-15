import 'dart:async';
import 'package:flutter/material.dart';

class MeditationTimerScreen extends StatefulWidget {
  const MeditationTimerScreen({Key? key}) : super(key: key);

  @override
  _MeditationTimerScreenState createState() => _MeditationTimerScreenState();
}

class _MeditationTimerScreenState extends State<MeditationTimerScreen> {
  late Stopwatch _stopwatch;
  bool _isRunning = false;
  late StreamSubscription<int> _timerSubscription;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the stopwatch but do not start it automatically
    _stopwatch = Stopwatch();
    _isRunning = false;
  }

  void _startTimer() {
    // Start the stopwatch and update UI every second
    _stopwatch.start();
    _timerSubscription = Stream.periodic(Duration(seconds: 1), (int _tick) {
      setState(() {
        _elapsedSeconds = _stopwatch.elapsed.inSeconds;
      });
      return _tick;
    }).takeWhile((_) => _isRunning).listen(null);
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    // Stop the stopwatch and cancel the timer subscription
    _stopwatch.stop();
    _timerSubscription.cancel();
    setState(() {
      _isRunning = false;
    });
    _recordSession();
  }

  void _resetTimer() {
    // Reset stopwatch, update UI, and cancel the timer subscription
    _stopwatch.reset();
    _timerSubscription.cancel();
    setState(() {
      _isRunning = false;
      _elapsedSeconds = 0;
    });
  }

  void _recordSession() {
    // Handle recording the session duration or updating progress
    Duration sessionDuration = _stopwatch.elapsed;
    print('Session recorded: ${sessionDuration.inMinutes} minutes');
    // Optionally reset stopwatch and elapsed time for a new session
    _stopwatch.reset();
    _elapsedSeconds = 0;
  }

  String _formattedTime(int seconds) {
    // Format seconds into minutes:seconds format
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits((seconds ~/ 60) % 60);
    String twoDigitSeconds = twoDigits(seconds % 60);
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    // Cancel the timer subscription to avoid memory leaks
    _timerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _formattedTime(_elapsedSeconds),
            style: TextStyle(fontSize: 48.0),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _isRunning ? _stopTimer : _startTimer,
                child: Text(_isRunning ? 'Stop' : 'Start'),
              ),
              const SizedBox(width: 20.0),
              ElevatedButton(
                onPressed: !_isRunning ? null : _resetTimer,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
