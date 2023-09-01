import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageTaskRepo {

  Future<void> createImageTask(String task, String description, String taskDuration, List<XFile> images, BuildContext context ) async {
    final uuid = Uuid();
    final taskId = uuid.v4();
    List<String> taskImages = [];
    final _auth = FirebaseAuth.instance;
    final CollectionReference imageTaskRef = FirebaseFirestore.instance.collection('imagetaskcollection');
    try {
  
  for(final element in images){
    final ref = FirebaseStorage.instance.ref().child('taskimages').child(element.name);
    final file = File(element.path);
    await ref.putFile(file);
    final imageUrl = await ref.getDownloadURL();
    taskImages.add(imageUrl);

  }
      await imageTaskRef.doc(taskId).set(
        {
          'userid' : _auth.currentUser!.uid,
          'taskid' : taskId,
          'task' : task,
          'description' : description,
          'taskduration' : taskDuration,
          'taskimage' :taskImages,
          
        }
      );
    }on FirebaseAuthException catch (e) {
      throw Exception('failed');
      
    }          

  }

}

//flutter pub add uuid ->comment for add id for task(for making id small)
//flutter upgrade maily uses when errors come
//flutter pub add image _picker to add image