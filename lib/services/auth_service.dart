import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      usuario = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> registrar(String email, String senha) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
