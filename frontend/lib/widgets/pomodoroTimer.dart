import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroTimerWidget extends StatefulWidget {
  @override
  _PomodoroTimerWidgetState createState() => _PomodoroTimerWidgetState();
}

class _PomodoroTimerWidgetState extends State<PomodoroTimerWidget> {
  static const int workDuration = 25 * 60; // 25 minutes in seconds
  static const int breakDuration = 5 * 60; // 5 minutes in seconds

  int _secondsRemaining = workDuration;
  bool _isRunning = false;
  bool _isBreak = false;
  Timer? _timer;

  void _startTimer() {
    if (_timer != null) _timer!.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer!.cancel();
          _isBreak = !_isBreak;
          _secondsRemaining = _isBreak ? breakDuration : workDuration;
        }
      });
    });
    setState(() => _isRunning = true);
  }

  void _pauseTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _isRunning = false;
      _isBreak = false;
      _secondsRemaining = workDuration;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isBreak ? "Break Time!" : "Work Session",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            _formatTime(_secondsRemaining),
            style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                onPressed: _isRunning ? _pauseTimer : _startTimer,
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white, size: 32),
                onPressed: _resetTimer,
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Stay focused and take breaks!",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
