import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===============================
  // CADASTRO
  // ===============================
  Future<User?> register({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) async {
    try {
      // 1️⃣ Cria o usuário no Firebase Auth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = credential.user!;

      // 2️⃣ Salva dados extras no Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'cpf': cpf,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Erro ao criar conta');
    }
  }

  // ===============================
  // LOGIN
  // ===============================
  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Erro ao fazer login');
    }
  }

  // ===============================
  // ATUALIZAR DADOS DO USUÁRIO
  // ===============================
  Future<void> updateUserData({
    required String name,
    required String email,
    required String cpf,
    String? phone,
    String? photoUrl,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
      'email': email,
      'cpf': cpf,
      'phone': phone,
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ===============================
  // LOGOUT
  // ===============================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ===============================
  // USUÁRIO ATUAL
  // ===============================
  User? get currentUser => _auth.currentUser;

  // ===============================
  // DADOS DO USUÁRIO (Firestore)
  // ===============================
  Future<Map<String, dynamic>?> getUserData() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    return doc.data();
  }
}
