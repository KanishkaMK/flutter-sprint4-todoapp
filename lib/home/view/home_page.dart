import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/imagetask/image_task.dart';
import 'package:todoapp/login/view/login_page.dart';

import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  final TextEditingController _taskdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late CollectionReference _todoRef;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todoRef = _firestore.collection('TaskCollection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 182, 250),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageTask(),
                        ));
                  },
                  icon: Icon(Icons.image)),

                  IconButton(
                    onPressed: () async {
                      await _auth.signOut().then((value) {
                        if(!mounted)
                        return;
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen(),), (route) => false);
                      });
                      
                    }, 
                    icon: Icon(Icons.logout)),

            ],
          )
        ],
        backgroundColor: Color.fromARGB(255, 146, 135, 244),
        title: Center(
          child: Text(
            "Welcome to home page",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            TextFormField(
              controller: _taskdController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please fill the field';
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Task'),
            ),

            SizedBox(
              height: 20,
            ),

            TextFormField(
              controller: _descriptionController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please fill the field';
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Description'),
            ),

            SizedBox(
              height: 10,
            ),

            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _todoRef.add({
                      'userid': _auth.currentUser!.uid,
                      'task': _taskdController.text,
                      'description': _descriptionController.text,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Task added successfully')));
                    _taskdController.clear();
                    _descriptionController.clear();
                  }

                  //  Navigator.push(

                  //     context,

                  //     MaterialPageRoute(

                  //       builder: (context) => HomePage(),

                  //     ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 146, 135, 244),
                ),
                child: Text(
                  'Add Task',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                )),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _todoRef
                    .where('userid', isEqualTo: _auth.currentUser?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final List<DocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final document = documents[index];
                      return ListTile(
                        title: Text(document['task'] as String),
                        subtitle: Text(document['description'] as String),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        final doc = documents[index];
                                        _taskdController.text =
                                            doc['task'] as String;
                                        _descriptionController.text =
                                            doc['description'] as String;
                                        return AlertDialog(
                                          title: Text('Edit Task'),
                                          content: Column(
                                            children: [
                                              // Title(color: Color.fromARGB(255, 146, 135, 244),
                                              // child: Text('Edit Task')),

                                              TextField(
                                                controller: _taskdController,
                                                decoration: InputDecoration(
                                                    hintText: 'task'),
                                              ),
                                              TextField(
                                                controller:
                                                    _descriptionController,
                                                decoration: InputDecoration(
                                                    hintText: 'Description'),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // IconButton(onPressed: () {

                                                  // }, icon: Icon(Icons.delete)),
                                                  // IconButton(onPressed: () {

                                                  // },
                                                  //  icon: Icon(Icons.cancel)),

                                                  ElevatedButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'TaskCollection')
                                                            .doc(document.id)
                                                            .update({
                                                          'task':
                                                              _taskdController
                                                                  .text,
                                                          'description':
                                                              _descriptionController
                                                                  .text,
                                                        });
                                                        _taskdController
                                                            .clear();
                                                        _descriptionController
                                                            .clear();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    'Updated Successfully')));
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                146, 135, 244),
                                                      ),
                                                      child: Text(
                                                        'SAVE',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      )),

                                                  //  SizedBox(width:10 ),

                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                146, 135, 244),
                                                      ),
                                                      child: Text(
                                                        'CANCEL',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  final todo = _todoRef.doc(document.id);
                                  todo.delete();

                                  // FirebaseFirestore.instance.collection('TaskCollection').doc(document.id).delete();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Deleted Successfully')));
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
