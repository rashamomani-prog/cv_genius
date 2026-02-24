import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class CVProvider with ChangeNotifier {
  UserModel? _userCV;
  bool _isLoading = false;

  UserModel? get userCV => _userCV;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String userId = _auth.currentUser!.uid;
      Reference ref = _storage
          .ref()
          .child('user_profiles')
          .child('$userId.jpg');

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("خطأ في رفع الصورة: $e");
      return "";
    }
  }
  Future<void> saveCVData(UserModel userModel) async {
    _isLoading = true;
    notifyListeners();

    try {
      String userId = _auth.currentUser!.uid;
      await _firestore
          .collection('users_cv')
          .doc(userId)
          .set(userModel.toMap(), SetOptions(merge: true));

      _userCV = userModel;
      print("تم حفظ البيانات بنجاح!");
    } catch (e) {
      print("خطأ في حفظ البيانات: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchUserCV() async {
    try {
      String userId = _auth.currentUser!.uid;
      DocumentSnapshot doc = await _firestore.collection('users_cv').doc(userId).get();

      if (doc.exists) {
        _userCV = UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        notifyListeners();
      }
    } catch (e) {
      print("خطأ في جلب البيانات: $e");
    }
  }
}