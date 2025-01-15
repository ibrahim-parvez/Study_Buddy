import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  bool isPomodoro = true; // Start with Pomodoro timer
  int pomodoroTime = 25 * 60; // 25 minutes in seconds
  int breakTime = 5 * 60; // 5 minutes break in seconds
  late int currentTime;

  @override
  void initState() {
    super.initState();
    // Initialize currentTime with pomodoroTime when the widget is created.
    currentTime = pomodoroTime;
  }

  void toggleTimer() {
    setState(() {
      // Toggle between Pomodoro and Break timer
      isPomodoro = !isPomodoro;
      currentTime = isPomodoro ? pomodoroTime : breakTime;
    });
  }

  // Function to show info dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What is the Pomodoro Technique?'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Pomodoro Technique is a time management method developed by Francesco Cirillo. It uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks. Here’s how it works:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '1. Set a timer for 25 minutes (a Pomodoro).',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '2. Work on the task until the timer rings.',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '3. Take a 5-minute break.',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '4. After four Pomodoros, take a longer break of 15-30 minutes.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
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
        automaticallyImplyLeading: false,
        title: Text(isPomodoro ? 'Pomodoro Timer' : 'Break Time'),
        actions: [
          // Info button to show the popup
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
          // Refresh button to toggle timer
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: toggleTimer,
          ),
        ],
      ),
      body: Center(
        child: Countdown(
          seconds: currentTime,
          build: (BuildContext context, double time) {
            // Format time as mm:ss
            int minutes = (time / 60).floor();
            int seconds = (time % 60).toInt();
            return Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            );
          },
          interval: Duration(seconds: 1),
          onFinished: () {
            // When the timer finishes, toggle between Pomodoro and Break
            toggleTimer();
            // Optionally show a message or perform any action when the timer ends
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isPomodoro ? 'Study Time Starts!' : 'Break Time Starts!'),
              ),
            );
          },
        ),
      ),
    );
  }
}
