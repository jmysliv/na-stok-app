class User {
  final String name;
  final String email;
  final String _id;

  User(this.name, this.email, this._id);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        _id = json['_id'];

  Map<String, dynamic> toJson() =>
      {
        '_id': _id,
        'name': name,
        'email': email,
      };
  @override
  String toString() => '{ _id: $_id, name: $name, email: $email';
}