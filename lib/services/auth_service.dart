import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_expenses_app/core/failures/failure.dart';
import 'package:my_expenses_app/core/failures/login_failure.dart';
import 'package:my_expenses_app/core/failures/login_firebase_failure.dart';
import 'package:my_expenses_app/core/failures/login_google_failure.dart';
import 'package:my_expenses_app/models/local_user.dart';

class AuthService {
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;

  Future<Either<Failure, LocalUser>> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final firebaseSignIn =
            await firebaseAuth.signInWithCredential(credentials);

        final firebaseUser = firebaseSignIn.user;

        if (firebaseUser != null) {
          final localUser = LocalUser(
            id: firebaseUser.uid,
            displayName: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
            createdAt: DateTime.now(),
          );

          return Right(localUser);
        } else {
          return Left(LoginFirebaseFailure(message: ''));
        }
      } else {
        return Left(LoginGoogleFailure(
            message: 'Error en la authentication de google'));
      }
    } catch (error) {
      return Left(LoginFailure(message: error.toString()));
    }
  }

  Future<Either<Failure, bool>> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();

    if (isLoggedIn) {
      return const Right(true);
    } else {
      return Left(LoginFailure(message: ''));
    }
  }
}
