import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;

  AuthException(FirebaseAuthException exception)
      : message = _translateFirebaseAuthException(exception);

  static String _translateFirebaseAuthException(
      FirebaseAuthException exception) {
    if (exception.code == 'user-not-found') {
      return 'No user found for that email.';
    } else if (exception.code == 'wrong-password') {
      return 'Wrong password provided for that user.';
    } else if (exception.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (exception.code == 'email-already-in-use') {
      return 'The account already exists for that email.';
    } else {
      return 'Given email or password is invalid or empty.';
    }
  }

  @override
  String toString() {
    return message;
  }
}
