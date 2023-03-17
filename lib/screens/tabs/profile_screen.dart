import 'package:flutter/material.dart';
import 'package:my_expenses_app/core/utilities/screen_state.dart';
import 'package:my_expenses_app/models/local_user.dart';
import 'package:my_expenses_app/screens/login_screen.dart';
import 'package:my_expenses_app/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _service = AuthService();
  var _screenState = ScreenState.idle;
  LocalUser? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    setState(() {
      _screenState = ScreenState.loading;
    });

    final either = await _service.getLocalUser();

    either.fold((l) {
      setState(() {
        _screenState = ScreenState.error;
      });
    }, (r) {
      setState(() {
        _screenState = ScreenState.completed;
        user = r;
      });
    });
  }

  void signOut() async {
    setState(() {
      _screenState = ScreenState.loading;
    });

    final either = await _service.googleSignOut();

    either.fold((l) {
      setState(() {
        _screenState = ScreenState.error;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.message)));
    }, (r) {
      setState(() {
        _screenState = ScreenState.completed;
      });

      Navigator.popUntil(context, (route) => Navigator.canPop(context));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return const LoginScreen();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_screenState.isLoading()) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () {
            return getUser();
          },
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                    user?.photoUrl ?? 'https://picsum.photos/200/300',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                user?.displayName ?? 'No Name',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.close),
                onPressed: () {
                  signOut();
                },
                label: const Text('Cerrar Sesion'),
              )
            ],
          ),
        ),
      );
    }
  }
}
