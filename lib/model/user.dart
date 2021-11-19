class NotesUser {
  NotesUser({
    required this.name,
    required this.email,
    required this.password,
  });

  String name;
  String email;
  String password;

  static NotesUser fromJson(final Map<String, dynamic> json) {
    return NotesUser(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}
