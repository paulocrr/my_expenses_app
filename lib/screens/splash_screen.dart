import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_app/screens/home_screen.dart';
import 'package:my_expenses_app/screens/login_screen.dart';
import 'package:my_expenses_app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _service = AuthService();

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  void isLoggedIn() async {
    final either = await _service.isLoggedIn();

    either.fold((l) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }, (r) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/burger-logo.png'),
          AnimatedTextKit(
            animatedTexts: [
              WavyAnimatedText('Cargando datos'),
              WavyAnimatedText('Obteniendo tu usuario'),
              WavyAnimatedText('Obteniendo tus gastos'),
            ],
          )
        ],
      ),
    );
  }
}
