import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CradWidget extends StatelessWidget {
   CradWidget({Key? key, required this.imageTask}):super(key: key);
  final QueryDocumentSnapshot<Map<String,dynamic>> imageTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     

      body: Center(
        child: Container(
          height: 200,
          width: 200,
          child: Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
        
            child: Column(
              children: [
               
                Image.network(imageTask['taskimage'][0].toString(),height: 50,width: 50,),
                 Text(imageTask['task'].toString()),
                Text(imageTask['taskduration'].toString()),
              ],
            ),
          ),
        ),
      ),


    );
  }
}