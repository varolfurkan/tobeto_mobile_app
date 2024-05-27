import 'package:flutter/material.dart';
import 'package:tobeto_mobile_app/auth/auth_service.dart';
import 'package:tobeto_mobile_app/screens/lessons.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterPage({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  Future<void> _register(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        await AuthService().signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LessonsPage()),
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextFormField('Ad*', Icons.perm_identity, firstNameController),
        const SizedBox(height: 10),
        _buildTextFormField('Soyad*', Icons.perm_identity, lastNameController),
        const SizedBox(height: 10),
        _buildTextFormField('E-Posta*', Icons.mail_outline, emailController),
        const SizedBox(height: 10),
        _buildTextFormField('Şifre*', Icons.lock, passwordController, obscureText: true),
        const SizedBox(height: 10),
        _buildTextFormField('Şifre Tekrar*', Icons.lock, confirmPasswordController, obscureText: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _register(context),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent.shade200),
            minimumSize: MaterialStateProperty.all<Size>(const Size(200, 50)),
          ),
          child: const Text(
            'Kayıt Ol',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(String labelText, IconData prefixIcon, TextEditingController controller, {bool obscureText = false}) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(prefixIcon),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bu alan boş bırakılamaz';
          }
          return null;
        },
      ),
    );
  }
}
