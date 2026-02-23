import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../models/user_model.dart';

class CVProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isSimple = true;
  bool get isSimple => _isSimple;

  User? get currentUser => _auth.currentUser;

  // تحديد نوع القالب عشان صفحة المعاينة
  void setTemplate(bool value) {
    _isSimple = value;
    notifyListeners();
  }

  // تسجيل الدخول
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  // حفظ البيانات باستخدام الـ UserModel (النسخة المعتمدة)
  Future<void> saveCVData(UserModel user) async {
    try {
      String collection = user.isSmart ? "smart_cvs" : "simple_cvs";
      await _firestore.collection(collection).doc(_auth.currentUser!.uid).set(user.toMap());
      notifyListeners();
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  // رفع الصورة
  Future<String> uploadProfileImage(File imageFile) async {
    String uid = _auth.currentUser!.uid;
    Reference ref = _storage.ref().child('profiles').child('$uid.jpg');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}