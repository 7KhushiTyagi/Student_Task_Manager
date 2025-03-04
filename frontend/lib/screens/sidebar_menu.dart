import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/authUser.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUser>(context);

    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          _buildHeader(authProvider),
          Expanded(child: _buildMenuItems(context)),
          _buildLogoutButton(context, authProvider),
        ],
      ),
    );
  }

  Widget _buildHeader(AuthUser authProvider) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.purple),
      accountName: Text(
        authProvider.isAuthenticated ? authProvider.userName : "Guest",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(authProvider.isAuthenticated ? authProvider.email : "guest@example.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Colors.purple, size: 40),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {

    final menuItems = [
      {'title': 'Goal Setting', 'icon': Icons.flag, 'route': '/goal_setting'},
      {'title': 'Calendar', 'icon': Icons.calendar_today, 'route': '/calendar'},
      {'title': 'Panic Button', 'icon': Icons.warning, 'route': '/panic'},
      {'title': 'AI Roadmap', 'icon': Icons.smart_toy, 'route': '/ai_roadmap'},
      {'title': 'Syllabus Tracker', 'icon': Icons.track_changes, 'route': '/syllabus_tracker'},
      {'title': 'Blog Posts', 'icon': Icons.article, 'route': '/blog_posts'},
      {'title': 'JEEGPT', 'icon': Icons.android, 'route': '/jeegpt'},
      {'title': 'Mentor Connect', 'icon': Icons.people, 'route': '/mentor_connect'},
      {'title': 'User Profile', 'icon': Icons.person, 'route': '/profile'},
    ];

    return ListView(
      shrinkWrap: true,
      children: menuItems.map((item) {
        return ListTile(
          leading: Icon(item['icon'] as IconData, color: Colors.purple),
          title: Text(item['title'] as String, style: TextStyle(color: Colors.white)),
          onTap: () => Navigator.pushNamed(context, item['route'] as String),
        );
      }).toList(),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthUser authProvider) {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red),
      title: Text("Logout", style: TextStyle(color: Colors.red)),
      onTap: () {
        authProvider.logout();
        Navigator.pushReplacementNamed(context, '/login'); // Redirect to Login
      },
    );
  }
}
