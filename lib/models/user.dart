class User {
  late String email = '';
  late String name;
  String? profileUrl;

  User({required String? email, name = '', this.profileUrl}) {
    this.email = email == null ? 'dummy@gmail.com' : email;

    this.name = name == '' ? this.email.split("@").first : name;
  }
}
