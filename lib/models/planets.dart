class Users {
  int? id;
  String name;
  int age;
  String email;

  Users({
    this.id,
    required this.name,
    required this.age,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'email': email,
    };
  }

  factory Users.fromMap(Map<String, dynamic> res) {
    return Users(
      id: res['id'] as int,
      name: res['name'] as String,
      age: res['age'] as int,
      email: res['email'] as String,
    );
  }
}
