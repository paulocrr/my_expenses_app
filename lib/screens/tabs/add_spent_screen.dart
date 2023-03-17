import 'package:flutter/material.dart';
import 'package:my_expenses_app/core/utilities/screen_state.dart';
import 'package:my_expenses_app/services/expenses_service.dart';

class AddSpentScreen extends StatefulWidget {
  const AddSpentScreen({super.key});

  @override
  State<AddSpentScreen> createState() => _AddSpentScreenState();
}

class _AddSpentScreenState extends State<AddSpentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _service = ExpensesService();
  var screenState = ScreenState.idle;

  @override
  Widget build(BuildContext context) {
    if (screenState.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    } else {
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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Text('Monto S/'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          screenState = ScreenState.loading;
                        });
                        final either = await _service.addSpent(
                          description: _descriptionController.text,
                          amount: double.parse(_amountController.text),
                        );
                        either.fold((l) {
                          setState(() {
                            screenState = ScreenState.error;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l.message),
                            ),
                          );
                        }, (r) {
                          setState(() {
                            screenState = ScreenState.completed;
                          });

                          _descriptionController.clear();
                          _amountController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Se guardo el gasto'),
                            ),
                          );
                        });
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

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
  }
}
