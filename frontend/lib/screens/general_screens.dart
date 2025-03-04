import 'package:flutter/material.dart';

// Common template for all screens with animations
class GenericScreen extends StatelessWidget {
  final String title;
  const GenericScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: 1.0,
        child: Center(
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0.8, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Text(
              title,
              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

// Screens with transition animation
class GoalSettingScreen extends StatelessWidget {
  const GoalSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
          },
          child: Text("Goal Setting"),
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "Calendar"),
    );
  }
}

class PanicScreen extends StatelessWidget {
  const PanicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "Panic Button"),
    );
  }
}

class AiRoadmapScreen extends StatelessWidget {
  const AiRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "AI Roadmap"),
    );
  }
}

class SyllabusTrackerScreen extends StatelessWidget {
  const SyllabusTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "Syllabus Tracker"),
    );
  }
}

class BlogPostsScreen extends StatelessWidget {
  const BlogPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "Blog Posts"),
    );
  }
}

class JeegptScreen extends StatelessWidget {
  const JeegptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "JEEGPT"),
    );
  }
}

class MentorConnectScreen extends StatelessWidget {
  const MentorConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "Mentor Connect"),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => _buildScreenWithTransition(context, "User Profile"),
    );
  }
}

// ✅ Slide transition for smoother navigation
PageRouteBuilder _buildScreenWithTransition(BuildContext context, String title) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => GenericScreen(title: title),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
