class User {
  final int id;
  final String firstName, lastName, username, email, photo, phone, language;
  final bool gender;
  final DateTime? createAt;

  User(
      {required this.id,
      required this.createAt,
      required this.email,
      required this.username,
      required this.firstName,
      required this.language,
      required this.gender,
      required this.lastName,
      required this.phone,
      required this.photo});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createAt = DateTime.tryParse(json['created_at']),
        email = json['email'],
        firstName = json['first_name'],
        language = json['lang'],
        username = json['username'],
        gender = json['sex'] == 'M' ? true : false,
        lastName = json['last_name'],
        phone = json['phone'],
        photo = json['photo'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createAt.toString(),
        'email': email,
        'first_name': firstName,
        'lang': language,
        'username': username,
        'gender': gender ? 'M' : 'F',
        'last_name': lastName,
        'phone': phone,
        'photo': photo,
      };
}
