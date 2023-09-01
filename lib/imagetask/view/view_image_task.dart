import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/widget/card_widget.dart';

class ViewImageTask extends StatelessWidget {
   ViewImageTask({super.key});
  final _auth = FirebaseAuth.instance;
  final _taskRef = FirebaseFirestore.instance.collection('imagetaskcollection'); 

@override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 189, 182, 250),
        title: Text('View Image Task'),
      ),
      body: StreamBuilder(
        stream: _taskRef.where('userid',isEqualTo: _auth.currentUser!.uid).snapshots(),

        builder: (context, snapshot) {
          if(snapshot.hasData){
          
          final task = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
              childAspectRatio: 0.7
              ), 
          itemCount: task.length,    
            itemBuilder: (BuildContext context, int index) {
                return CradWidget(imageTask: task[index]);
            },);

 
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
          
        },
      ),
    );
  }
}
