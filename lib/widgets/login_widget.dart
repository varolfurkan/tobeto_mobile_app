import 'package:flutter/material.dart';
import 'package:tobeto_mobile_app/auth/auth_service.dart';
import 'package:tobeto_mobile_app/screens/lessons.dart';

class LoginPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginPage({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    if (widget.formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await AuthService().signInWithEmailAndPassword(
          widget.emailController.text,
          widget.passwordController.text,
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

  Future<void> _signInWithGoogle(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthService().signInWithGoogle();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LessonsPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google ile girişte bir hata oluştu.: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return Column(
      children: [
        _buildTextFormField('E-Posta Adresi', Icons.mail_outline, widget.emailController),
        const SizedBox(height: 10),
        _buildTextFormField('Şifre', Icons.lock_outline, widget.passwordController, obscureText: true),
        const SizedBox(height: 20),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () => _signInWithEmailAndPassword(context),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.deepPurpleAccent.shade200),
            minimumSize: WidgetStateProperty.all<Size>(const Size(200, 50)),
          ),
          child: const Text(
            'Giriş Yap',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Ya da',
                style: TextStyle(fontSize: 24),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _signInWithGoogle(context),
          child: Image.asset(
            'img/google_login.png',
            width: size / 2,
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
