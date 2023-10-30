/// The User class represents a user with properties such as id, email, fullName, roles, and token, and
/// provides a method to check if the user is an admin.
class User {
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final String token;

  User(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.roles,
      required this.token});

  bool get isAdmin {
    return roles.contains('admin');
  }
}
