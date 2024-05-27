import 'package:flutter/material.dart';
import 'package:tobeto_mobile_app/auth/auth_service.dart';
import 'package:tobeto_mobile_app/screens/lessons.dart';

class RegisterPage extends StatefulWidget {
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

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;

  Future<void> _register(BuildContext context) async {
    if (widget.formKey.currentState?.validate() ?? false) {
      if (widget.passwordController.text != widget.confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Şifreler eşleşmiyor.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        String displayName = '${widget.firstNameController.text} ${widget.lastNameController.text}';
        await AuthService().signUpWithEmailAndPassword(
          widget.emailController.text,
          widget.passwordController.text,
          displayName,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LessonsPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextFormField('Ad*', Icons.perm_identity, widget.firstNameController),
        const SizedBox(height: 10),
        _buildTextFormField('Soyad*', Icons.perm_identity, widget.lastNameController),
        const SizedBox(height: 10),
        _buildTextFormField('E-Posta*', Icons.mail_outline, widget.emailController),
        const SizedBox(height: 10),
        _buildTextFormField('Şifre*', Icons.lock, widget.passwordController, obscureText: true),
        const SizedBox(height: 10),
        _buildTextFormField('Şifre Tekrar*', Icons.lock, widget.confirmPasswordController, obscureText: true),
        const SizedBox(height: 20),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () => _register(context),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.deepPurpleAccent.shade200),
            minimumSize: WidgetStateProperty.all<Size>(const Size(200, 50)),
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
