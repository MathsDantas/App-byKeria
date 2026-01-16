import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<String> uploadProfilePhoto(File image) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final ref = _storage.ref().child('profile_photos').child('${user.uid}.jpg');

    await ref.putFile(image);

    final url = await ref.getDownloadURL();

    await _firestore.collection('users').doc(user.uid).update({
      'photoUrl': url,
    });

    return url;
  }

  /// Atualizar nome e/ou avatar
  Future<void> updateProfile({
    required String name,
    String? phone,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _firestore.collection('users').doc(user.uid).update({
      'name': name,
      if (phone != null) 'phone': phone,
      if (photoUrl != null) 'photoUrl': photoUrl,
    });
  }

  /// Selecionar imagem da galeria
  Future<File?> pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return null;
    return File(picked.path);
  }
}
