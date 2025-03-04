import 'package:flutter/material.dart';
import 'package:frontend/providers/authUser.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authUser = Provider.of<AuthUser>(context, listen: false);
      bool success = (await authUser.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      )) as bool;

      if (success) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _shakeController.forward(from: 0);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Transform.translate(
              offset: Offset(_shakeAnimation.value, 0), // Shake effect
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _animatedScaleText("Welcome Back!", 24, FontWeight.bold),
                  const SizedBox(height: 20),
                  _animatedTextField(_emailController, "Email"),
                  const SizedBox(height: 16),
                  _animatedTextField(_passwordController, "Password", isPassword: true),
                  const SizedBox(height: 20),
                  authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.purple)
                      : _buildLoginButton(context),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.purple),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _animatedScaleText(String text, double fontSize, FontWeight fontWeight) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.8, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }

  Widget _animatedTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.8, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) => value!.isEmpty ? "Please enter your $label" : null,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _login(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
