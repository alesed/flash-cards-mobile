import 'package:flashcards/features/auth/services/auth_service.dart';
import 'package:flashcards/locator.dart';
import 'package:flashcards/widgets/form_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthenticationService>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 96),
              Icon(Icons.lock, size: 128),
              SizedBox(height: 48),
              Text(
                "Welcome back, you've been missed!",
              ),
              SizedBox(height: 32),
              _buildInputForm(emailController, passwordController),
              SizedBox(height: 32),
              _buildAuthButton('Login', () async {
                await authService.login(
                  emailController.text,
                  passwordController.text,
                );
              }),
              SizedBox(height: 16),
              _buildAuthButton('Register', () async {
                await authService.createAccount(
                  emailController.text,
                  passwordController.text,
                );
              }),
              SizedBox(height: 48),
              _buildDivider(),
              SizedBox(height: 48),
              _buildSocialSitesLogin(() async {
                await authService.loginWithGoogle();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Form _buildInputForm(
  TextEditingController emailController,
  TextEditingController passwordController,
) {
  return Form(
    child: Column(
      children: [
        FormInput(
          controller: emailController,
          hintText: 'Email',
        ),
        SizedBox(height: 8),
        FormInput(
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
        )
      ],
    ),
  );
}

SizedBox _buildAuthButton(String text, Function() onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

Row _buildDivider() {
  return Row(
    children: [
      Expanded(
        child: Divider(
          thickness: 0.5,
        ),
      ),
      Text("Or continue with"),
      Expanded(
        child: Divider(
          thickness: 0.5,
        ),
      ),
    ],
  );
}

Row _buildSocialSitesLogin(Function() googleLoginFn) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        width: 106,
        height: 106,
        child: ElevatedButton(
          onPressed: googleLoginFn,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
          ),
          child: Image.asset('assets/images/google.png', width: 64),
        ),
      ),
    ],
  );
}
