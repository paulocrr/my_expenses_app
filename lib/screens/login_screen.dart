import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:my_expenses_app/core/utilities/screen_state.dart';
import 'package:my_expenses_app/screens/home_screen.dart';
import 'package:my_expenses_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var screenState = ScreenState.idle;
  final authService = AuthService();

  void handleSignInWithGoogle() async {
    setState(() {
      screenState = ScreenState.loading;
    });

    final either = await authService.signInWithGoogle();

    either.fold((failure) {
      setState(() {
        screenState = ScreenState.error;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.message),
        ),
      );
    }, (r) {
      // guardar en shared el token
      setState(() {
        screenState = ScreenState.completed;
      });

      Navigator.popUntil(context, (route) => Navigator.canPop(context));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return const HomeScreen();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/burger-logo.png',
                  width: 240,
                ),
                const SizedBox(height: 64),
                if (screenState.isLoading()) ...[
                  const CircularProgressIndicator()
                ] else ...[
                  SizedBox(
                    width: double.maxFinite,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xfffcbb22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Continue with Email'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.maxFinite,
                    height: 42,
                    child: SignInButton(
                      Buttons.Apple,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.maxFinite,
                    height: 42,
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        handleSignInWithGoogle();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.maxFinite,
                    height: 42,
                    child: SignInButton(
                      Buttons.FacebookNew,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Dont have an account '),
                      Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xfffcbb22),
                        ),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
