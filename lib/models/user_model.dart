class Userakun {
  final int? idUser;
  final String username;
  final String password;

  Userakun({this.idUser, required this.username, required this.password});

  // Metode untuk mengonversi dari JSON
  factory Userakun.fromJson(Map<String, dynamic> json) {
    return Userakun(
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
