import 'package:confetti/confetti.dart' as confetti;
import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  const ConfettiWidget({super.key});

  @override
  _ConfettiWidgetState createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> {
  late confetti.ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = confetti.ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void playConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: confetti.ConfettiWidget(  // Use the package's widget explicitly
        confettiController: _confettiController,
        blastDirectionality: confetti.BlastDirectionality.explosive,
        shouldLoop: false,
        maxBlastForce: 5,
        minBlastForce: 2,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.1,
        colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
      ),
    );
  }
}
