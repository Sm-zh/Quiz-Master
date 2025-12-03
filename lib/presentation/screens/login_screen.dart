import 'package:flutter/material.dart';
import '../../data/data_repository/auth_repository.dart';
import '../../data/models/user.dart';
import 'create_account_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthRepository authRepository;

  const LoginScreen({super.key, required this.authRepository});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final User loggedInUser = await widget.authRepository.login(
        email: email,
        password: password,
      );

      final token = await widget.authRepository.tokenStorage.getToken();
      _showSnackbar(
        'Login Successful! Welcome, ${loggedInUser.name}. Token saved: ${token != null}',
        Colors.green,
      );
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(role: loggedInUser.role, token: token!),
        ),
        (Route<dynamic> route) => false,
      );
    } on Exception catch (e) {
      _showSnackbar(
        'Login Failed: ${e.toString().replaceAll('Exception: ', '')}',
        Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppLogo(),
                const SizedBox(height: 40),

                _buildInputField(
                  controller: _emailController,
                  hint: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildInputField(
                  controller: _passwordController,
                  hint: 'Password',
                  icon: Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                _buildCreateAccountLink(),
                const SizedBox(height: 30),

                _buildSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz_outlined, color: Colors.white, size: 50),
              Text(
                'QuizMaster',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCreateAccountLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => CreateAccountScreen(
                    authRepository: widget.authRepository,
                  ),
                ),
              );
            },
            child: const Text(
              'Create One',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
