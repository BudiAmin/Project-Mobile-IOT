class User {
  final int? idUser;
  final String email;
  final String password;

  User({this.idUser, required this.email, required this.password});

  // Metode untuk mengonversi dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user'],
      email: json['email'],
      password: json['password'],
    );
  }

  // Metode untuk mengonversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'email': email,
      'password': password,
    };
  }
}
