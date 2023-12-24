
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

File? _imgfile;
loginTextField({controller,text,icon,type}){
  return TextFormField(controller: controller,
  validator: (value){
                  if(value==null || value.isEmpty) {
                    return "Field Cannot be empty";
                  }

                  return null;},
  
  keyboardType:type ,
  style:TextStyle(height: 1),
  strutStyle: StrutStyle(height: 0.5),
  decoration: InputDecoration(label: Text(text),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),gapPadding: 10.0),
  prefixIcon: Icon(icon))
  );
}
loginTextFieldfixed({controller,text,icon,type}){
  return TextFormField(controller: controller,
  validator: (value){
                  if(value==null || value.isEmpty) {
                    return "Field Cannot be empty";
                  }

                  return null;},
  
  keyboardType:type ,
  readOnly: true,
  style:TextStyle(height: 1),
  strutStyle: StrutStyle(height: 0.5),
  decoration: InputDecoration(label: Text(text),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),gapPadding: 10.0),
  prefixIcon: Icon(icon))
  );
}
loginemailTextField({controller,text,icon,type}){
  return TextFormField(controller: controller,
  validator: (value){
                  if(value==null || value.isEmpty) {
                    return "Field Cannot be empty";
                  }
                  else if(!(value.contains("@") && value.contains(".com")))
                  {
                    return "Please enter Valid Email";
                  }
                  return null;},
  keyboardType:type ,
  style:TextStyle(height: 1),
  strutStyle: StrutStyle(height: 0.5),
  decoration: InputDecoration(label: Text(text),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),gapPadding: 10.0),
  prefixIcon: Icon(icon))
  );
}
Future getimage(context)
async {
await showDialog(context: context, builder:(builder){
                              return AlertDialog(
                                title: Text("Choose your sorce"),
                                actions: [
                                  TextButton(onPressed: () async {
                                     final ImagePicker _picker = ImagePicker();
                  // Pick an image
                                   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                                   if(image!=null){
                                   _imgfile=File(image.path);
                                   }
                                   Navigator.of(context).pop();  
                                  }, child: Text("Gallery"),
                                  ),
                      
                                  TextButton(onPressed: ()async {
                                    final ImagePicker _picker = ImagePicker();
                  // Pick an image
                                   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                                   if(image!=null){
                                   _imgfile=File(image.path);
                                   }
                                   Navigator.of(context).pop();
                      
                                  }, child: Text("Camera"),
                                  )
                                ],
                      
                              );
                            });
  return _imgfile;
}

Container categorycontainer(path,text)
{
return Container(
                  height: 80, 
                  width: 100,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0),color: Colors.amber),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 22 ,child: ClipOval(child: Image.network(path),),),
                    SizedBox(height: 5,),
                    Text(text,style: TextStyle(color: Colors.purple,fontSize: 14.0,fontWeight: FontWeight.bold),)
                  
                ],),);
}