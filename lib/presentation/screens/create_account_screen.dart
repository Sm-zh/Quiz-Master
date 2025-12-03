import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/auth_repository.dart';
import 'login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  final AuthRepository authRepository;
  const CreateAccountScreen({super.key, required this.authRepository});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedRoleIndex = 0;
  bool _isLoading = false;
  static const List<String> _roles = ['student', 'teacher'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _selectRole(int index) {
    setState(() {
      _selectedRoleIndex = index;
    });
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final role = _roles[_selectedRoleIndex];
      final user = await widget.authRepository.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: role,
      );

      _showSnackbar(
        'Account created successfully for ${user.name} as $role.',
        Colors.green,
      );

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              LoginScreen(authRepository: widget.authRepository),
        ),
      );
    } on Exception catch (e) {
      _showSnackbar(
        'Registration Failed: ${e.toString().replaceAll('Exception: ', '')}',
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

                _buildRoleSwitcher(),
                const SizedBox(height: 30),

                _buildInputField(
                  controller: _nameController,
                  hint: 'User Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your user name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildInputField(
                  controller: _emailController,
                  hint: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                _buildLoginLink(),
                const SizedBox(height: 30),

                _buildSignUpButton(),
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

  Widget _buildRoleSwitcher() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _buildRoleButton(
            text: 'Student',
            index: 0,
            isSelected: _selectedRoleIndex == 0,
          ),
          _buildRoleButton(
            text: 'Teacher',
            index: 1,
            isSelected: _selectedRoleIndex == 1,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton({
    required String text,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _selectRole(index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.grey[600],
            ),
          ),
        ),
      ),
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

  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Have an account?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      LoginScreen(authRepository: widget.authRepository),
                ),
              );
            },
            child: const Text(
              'Login',
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

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signUp,
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
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
