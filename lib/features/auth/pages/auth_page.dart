import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/login_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(
              r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]{1,10}@[a-zA-Z0-9-]{1,10}(?:\.[a-zA-Z0-9-]{2,10})+$")
          .hasMatch(value)) {
        return 'Invalid email format';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 6 || value.length > 10) {
        return 'Password must be between 6 and 10 characters';
      }
      if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,10}$')
          .hasMatch(value)) {
        return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
      }
    }
    return null;
  }

  void _loginPressed() {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(LoginRequested(
        email: emailController.text, password: passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign In",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: Adaptive.h(7)),
            AuthTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
              controller: emailController,
              validator: validateEmail,
               onChanged: (_) {
                setState(() {
                  emailError = validatePassword(emailController.text);
                });
              },
            ),
            SizedBox(height: Adaptive.h(5)),
            AuthTextField(
              labelText: 'Password',
              hintText: 'Enter your password',
              isPassword: true,
              controller: passwordController,
              validator: validatePassword,
              onChanged: (_) {
                setState(() {
                  passwordError = validatePassword(passwordController.text);
                });
              },
            ),
            SizedBox(height: Adaptive.h(7)),
            LoginButton(onTap: () {
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                _loginPressed();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Check your email and password, or network"),
                ));
              }
            }),
          ],
        ),
      ),
    );
  }
}
