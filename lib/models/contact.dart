class Contact {
  int? id;
  String name;
  String mobileNo;
  String email;
  int favorite;

  Contact({
    this.id,
    required this.name,
    required this.mobileNo,
    required this.email,
    this.favorite = 0,
  });

  Contact.fromMap(Map<String, dynamic> cMap)
      : id = cMap['id'],
        name = cMap['name'],
        mobileNo = cMap['mobile'],
        email = cMap['email'],
        favorite = cMap['favorite'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "mobile": mobileNo,
      "email": email,
      "favorite": favorite
    };
  }

  Contact copyWith({int? id, String? name, String? mobileNo, String? email}) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
    );
  }
}
