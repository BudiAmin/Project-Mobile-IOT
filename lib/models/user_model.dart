class User {
  final int? idUser;
  final String username;
  final String password;

  User({this.idUser, required this.username, required this.password});

  // Metode untuk mengonversi dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user'],
      username: json['username'],
      password: json['password'],
    );
  }

  // Metode untuk mengonversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'username': username,
      'password': password,
    };
  }
}
