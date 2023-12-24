import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_image/Models/group.dart';
import 'package:sharing_image/MyWidget/constants.dart';
import 'package:sharing_image/groupImages.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // List<Group> groups = [];
  final TextEditingController _link = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: buildGroupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          _showCreateGroupDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildGroupList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _link,
                     decoration: InputDecoration(
                  labelText: 'Enter Link to Join Group',
                  prefixIcon: const Icon(Icons.link),
                  
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  
                  ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  height: 60,width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group_add,color: Colors.white,size: 16,),
                      const SizedBox(height: 5,),
                      Text('Join Group',textAlign: TextAlign.center , style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.white),),
                    ],
                  ),
                ),
              
              ],
            ),
            const SizedBox(height: 20,),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('groups').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              // Updated: Retrieve the groups from the snapshot
              List<Group> groups = snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                print(data.values.first);
                return Group.fromFirestore(data);
                
              }).toList();

              return Container(
                height: 300,
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return buildGroupCard(groups[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildGroupCard(Group group) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>groupImages(g: group)));
        },
        child: Container(
          height: 100, width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/background.jpg'),fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(12.0),
        
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.name,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,color: Colors.white),),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.normal,color: Colors.white),),
                    Text("Members: ${group.members.length}",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.normal,color: Colors.white),),
                    
                  ],
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),
    );
    // return Card(
    //   margin: EdgeInsets.all(10),
    //   child: ListTile(
    //     title: Text(group.name),
    //     subtitle: Text('Members: ${group.members.length}'),
    //     // Add more styling or widgets as needed
    //   ),
    // );
  }

  Future<void> _showCreateGroupDialog() async {
    TextEditingController groupNameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 241, 241, 241),
          title: Text('Create Group'),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(
              labelText: 'Group Name',
              prefixIcon: Icon(Icons.group),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              
              ),
              
              
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (groupNameController.text.isNotEmpty) {

                   SharedPreferences prefs = await SharedPreferences.getInstance();
                  // Save user data to SharedPreferences
                String? userId =  prefs.getString('userUid');


                   Group newGroup = Group(
                  name: groupNameController.text,
                  date: DateTime.now().toString(),
                  link: '',
                  members: [userId!],
                );

                 String Link = await generateGroupLink(newGroup);

                // Update the group link
                newGroup.link = Link;

                // Add the group to Firestore
                await addGroupToFirestore(newGroup);

                 showSnackBar(context, "Group Create Successfully", Colors.green);

                } else {
                  showSnackBar(context, "Please Enter Group Name", Colors.red);
                }
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
 Future<String> generateGroupLink(Group group) async {
  // You can define your own server or URL structure for generating group links.
  // For simplicity, this example just uses a direct URL.
  return 'https://sharingcaringimages/groups/${group.name}?admin=${group.members[0]}';
}


  // Function to add the group to Firestore
Future<void> addGroupToFirestore(Group group) async {
  try {
    // Reference to the 'groups' collection in Firestore
    CollectionReference groupsCollection = FirebaseFirestore.instance.collection('groups');

    // Add the group data to Firestore
       await groupsCollection.add(group.toFirestoreMap());


    print('Group added to Firestore successfully');
  } catch (e) {
    print('Error adding group to Firestore: $e');
    // Handle the error as needed
  }
}
}
