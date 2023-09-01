import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignupRepo {
  Future<void> createUser(String name, String place, String phone, String email, String password, BuildContext context ) async {
    final _auth = FirebaseAuth.instance;
    final CollectionReference userRef = FirebaseFirestore.instance.collection('usercollection');
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userRef.doc(userCredential.user!.uid).set(
        {
          'userid' : _auth.currentUser!.uid,
          'name' : name,
          'place' : place,
          'email' : email,
          'phone' : phone,
          'password' : password,
        }
      );
    }on FirebaseAuthException catch (e) {
      throw Exception('Signup failed');
      
    }          

  }
} 
