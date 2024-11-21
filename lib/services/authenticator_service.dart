import 'package:firebase_auth/firebase_auth.dart';

class AuthenticatorService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String?> registerUser({
    required String name,
    required String password,
    required String email,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "O usuario ja esta cadastrado";
      }
      return "Erro ao cadastrar usuario";
    }
  }

  Future<String?> loginUsers(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    return _firebaseAuth.signOut();
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Nenhum usuário encontrado para este email';
      } else if (e.code == 'invalid-email') {
        return 'Email inválido';
      }
      return 'Erro ao tentar redefinir a senha';
    }
  }
}
