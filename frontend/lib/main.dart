import 'package:flutter/material.dart';
import 'package:frontend/providers/authUser.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/task_provider.dart';
import 'package:frontend/screens/add_task_screen.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()), // ✅ Token provider
        ChangeNotifierProvider(create: (context) => AuthUser()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<void> _initAuth;

  @override
  void initState() {
    super.initState();
    _initAuth = _initializeAuth();
  }

  // ✅ Load token before UI builds
  Future<void> _initializeAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initAuth,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()), // ✅ Show loader while initializing
            ),
          );
        } else {
          return Consumer<AuthUser>(
            builder: (context, authUser, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Your App',
                theme: ThemeData.dark(),
                initialRoute: authUser.isAuthenticated ? '/dashboard' : '/signup',
                routes: {
                  '/signup': (context) => RegisterScreen(),
                  '/dashboard': (context) => DashboardScreen(),
                  '/new_task': (context) => NewTaskScreen(),
                },
              );
            },
          );
        }
      },
    );
  }
}
