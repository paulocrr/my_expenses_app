import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:my_expenses_app/core/failures/failure.dart';
import 'package:my_expenses_app/core/failures/firestore_failure.dart';
import 'package:my_expenses_app/core/failures/generic_failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesService {
  final firebaseStore = FirebaseFirestore.instance;

  Future<Either<Failure, void>> addSpent({
    required String description,
    required double amount,
  }) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final userId = sharedPreferences.getString('user_id');

      await firebaseStore.collection('expenses').add({
        'description': description,
        'amount': amount,
        'userId': userId,
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? ''));
    } catch (e) {
      return Left(GenericFailure(message: 'Ocurrio un error'));
    }
  }
}
