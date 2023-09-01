import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoapp/imagetask/repository/image_task_repo.dart';
import 'package:todoapp/imagetask/view/view_image_task.dart';

class ImageTask extends StatelessWidget {
   ImageTask({super.key});
   
   final TextEditingController _taskdController = TextEditingController();
   final TextEditingController _descriptionController = TextEditingController();
   final TextEditingController _taskDurationController = TextEditingController();
   final _formKey = GlobalKey<FormState>();

   List<XFile> imageList = [] ;

   Future<dynamic> getImage() async{
    final imagePicker = ImagePicker();
    imageList = await imagePicker.pickMultiImage();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 189, 182, 250),
        title: Text('Image Task'),

      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: _taskdController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please fill the field';
                }
              },
               decoration: InputDecoration(
                 focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Task'),
            ),
            TextFormField(
              controller: _descriptionController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please fill the field';
                }
              },
               decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                        border: OutlineInputBorder(
                         
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Description'),
            ),
            TextFormField(
              controller: _taskDurationController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please fill the field';
                }
              },
               decoration: InputDecoration(
                 focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Task Duration'),
            ),

           


            TextButton(onPressed: () {
              getImage();
              
            },
             child: Text('Upload Image')),

              ElevatedButton(onPressed: () async {

                 if(_formKey.currentState!.validate()){
                await ImageTaskRepo().createImageTask(
                  _taskdController.text,
                  _descriptionController.text, 
                  _taskDurationController.text, 
                  imageList!,
                  context);
                 }

                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image Task added Successfully')));
              
            }, 
             style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 146, 135, 244),
                ),
            child: Text(
                  'Add Image Task',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                )),

                TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewImageTask()));
            },
             child: Text('View Image Task')),


                

          ],
        ),
      ),


    );
  }
}

//task name,task desc,task duration,upload image text button,elevated but add image task


//todo task-button to view image task,route to a page where card widget contain image and textforms.