class UserModel {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final DateTime joinedOn;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.joinedOn,
  });
}
