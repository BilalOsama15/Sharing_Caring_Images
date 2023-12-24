// class Group {
//   String id='';
//   String name;
//   String date;
//   String link;
//   List<String> members;

//   Group({ required this.name, required this.date, required this.link, required this.members});
// }

class Group {
  String id; // Make id nullable
  String name;
  String date;
  String link;
  List<String> members;

  // Constructor with a named parameter for id, which is nullable
  Group({required this.name, required this.date, required this.link, required this.members, this.id = ''});

  // Named constructor for creating a Group instance from Firestore data
  Group.fromFirestore(Map<String, dynamic> data)
      : id = data['id'] ?? '', // Provide a default value for null id
        name = data['name'] ?? '',
        date = data['date'] ?? '',
        link = data['link'] ?? '',
        members = List<String>.from(data['members'] ?? []);

  // Helper method to convert Group instance to a map for Firestore
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'link': link,
      'members': members,
    };
  }
}
