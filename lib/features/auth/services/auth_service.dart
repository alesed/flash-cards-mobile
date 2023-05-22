import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards/features/auth/models/auth_exception.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final Stream<User?> _authStateChanges =
      FirebaseAuth.instance.authStateChanges();

  AuthenticationService() : _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authState => _authStateChanges;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> login(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e);
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> createAccount(
    String email,
    String password,
  ) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e);
    }
  }
}
