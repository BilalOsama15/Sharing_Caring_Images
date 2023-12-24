import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_image/Models/group.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sharing_image/ShowFullImage.dart';


class groupImages extends StatefulWidget {
   Group g ;
   groupImages({required this.g, super.key});

  @override
  State<groupImages> createState() => _groupImagesState();
}

class _groupImagesState extends State<groupImages> {
  List<XFile>? _imageList = [];
  final ImagePicker _picker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {
    print(widget.g.id);
    return Scaffold(
      appBar: AppBar(title: Text(widget.g.name)),
      floatingActionButton: floatingButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(height: 50,width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Members: ${widget.g.members.length.toString()}",
                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),

                    Container(
                  height: 40,width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 231, 231),
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_add,color: const Color.fromARGB(255, 0, 0, 0),size: 16,),
                      const SizedBox(width: 5,),
                      Text('Share Link',textAlign: TextAlign.center , style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.black),),
                    ],
                  ),
                ),
            

                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display selected images
            if (_imageList != null && _imageList!.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // You can adjust the number of columns as needed
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                  itemCount: _imageList!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'image_$index',
                        child: GestureDetector(
                          onTap: (){
                            _showFullScreenImage(index);
                          },
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            child: Image.file(File(_imageList![index].path),fit: BoxFit.cover,)),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget floatingButton() {
    return GestureDetector(
      onTap: (){
        _pickImages();
      },
      child: Container(
        height: 40,width: 110,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
      
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,size: 14.0,weight:30.0,color: Colors.white,),
            SizedBox(width: 10,),
            Text("Add Photos",style: TextStyle(color: Colors.white ,fontSize: 12.0,fontWeight: FontWeight.bold),)
          
          ],
        ),
      ),
    );
  }

  
  Future<void> _pickImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage();

      if (pickedImages != null) {
        setState(() {
          _imageList = pickedImages;
        });

        // Upload images to Firebase Storage
        await _uploadImagesToStorage();
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  Future<void> _uploadImagesToStorage() async {
    try {
      for (var imageFile in _imageList!) {
        final imageName = DateTime.now().millisecondsSinceEpoch.toString();
        final imageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('group_images/${widget.g.id}/$imageName.jpg');

        await imageRef.putFile(File(imageFile.path));

        final imageUrl = await imageRef.getDownloadURL();

        // Save image URL or perform other actions (e.g., update Firestore)
        print('Image uploaded. URL: $imageUrl');
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  void _showFullScreenImage(int index) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FullScreenImage(imagePath: _imageList![index].path),
    ),
  );
}

}