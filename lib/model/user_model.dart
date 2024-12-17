class User {
  final String name;
  final String email;
  final String address;
  final String? id;

  User({
    required this.name,
    required this.email,
    required this.address,
    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "address": address,
    };
  }
}
