import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Group> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Management'),
      ),
      body: buildGroupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateGroupDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildGroupList() {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return buildGroupCard(groups[index]);
      },
    );
  }

  Widget buildGroupCard(Group group) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(group.name),
        subtitle: Text('Members: ${group.members.length}'),
        // Add more styling or widgets as needed
      ),
    );
  }

  Future<void> _showCreateGroupDialog() async {
    TextEditingController groupNameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Group'),
          content: TextField(
            controller: groupNameController,
            decoration: InputDecoration(labelText: 'Group Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (groupNameController.text.isNotEmpty) {
                  setState(() {
                    groups.add(Group(name: groupNameController.text, members: []));
                  });
                  Navigator.of(context).pop();
                } else {
                  // Show an error message or handle the case when the group name is empty
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class Group {
  String name;
  List<String> members;

  Group({required this.name, required this.members});
}