class User {
  String uid;
  String name;
  String email;
  String type; //one of ["Student", "Facilitator", "Alumni"]
  String imageURL;

  User(this.uid, this.name, this.email, this.type, this.imageURL);

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'type': type,
    'imageURL': imageURL
  };

  User.fromJson(Map<dynamic, dynamic> data) :
        uid = data['uid'],
        name = data['name'],
        email = data['email'],
        type = data['type'],
        imageURL = data['imageURL'];

}