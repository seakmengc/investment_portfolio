class User {
  String email;
  String name;
  String? password;

  User({required this.email, this.password, this.name = ''}) {
    if (this.name == '') {
      this.name = this.email.split("@").first;
    }
  }
}
