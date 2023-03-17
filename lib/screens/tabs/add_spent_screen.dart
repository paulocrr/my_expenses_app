import 'package:flutter/material.dart';

class AddSpentScreen extends StatefulWidget {
  const AddSpentScreen({super.key});

  @override
  State<AddSpentScreen> createState() => _AddSpentScreenState();
}

class _AddSpentScreenState extends State<AddSpentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Agrega un nuevo gasto aqui',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32.0),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este valor es requerido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: const Text('Descripcion'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este valor es requerido';
                    } else {
                      try {
                        double.parse(value);
                        return null;
                      } catch (e) {
                        return 'Este campo debe ser un numero';
                      }
                    }
                  },
                  decoration: InputDecoration(
                    label: const Text('Monto S/'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('tap');
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
