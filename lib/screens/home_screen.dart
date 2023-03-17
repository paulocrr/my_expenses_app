import 'package:flutter/material.dart';
import 'package:my_expenses_app/screens/tabs/add_spent_screen.dart';
import 'package:my_expenses_app/screens/tabs/list_expenses_screen.dart';
import 'package:my_expenses_app/screens/tabs/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _tabs = [
    ListExpensesScreen(),
    AddSpentScreen(),
    ProfileScreen(),
  ];

  var _currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentScreen],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Gastos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _currentScreen,
        onTap: (index) {
          setState(() {
            _currentScreen = index;
          });
        },
      ),
    );
  }
}
