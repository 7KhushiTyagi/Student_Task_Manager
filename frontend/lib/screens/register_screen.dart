import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar("All fields are required", Colors.red);
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar("Enter a valid email", Colors.red);
      return;
    }

    final response = await authProvider.register(name, email, password);

    if (!mounted) return; // Prevents calling setState if widget is disposed

    if (response['success']) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _showSnackBar(response['message'] ?? "Registration failed. Try again.", Colors.red);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(email);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: MediaQuery.of(context).size.height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text("Sign up to get started!", style: TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 40),
              _buildTextField(_nameController, "Name", Icons.person),
              const SizedBox(height: 20),
              _buildTextField(_emailController, "Email", Icons.email),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : () => _register(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?", style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text("Login", style: TextStyle(color: Colors.purple)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: _inputDecoration("Password", Icons.lock).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white12,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
