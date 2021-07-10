class User {
  final String email;
  final String fullName;
  final String userRole;

  User({required this.fullName, required this.email, this.userRole = 'User'});

  User.fromData(Map<String, dynamic> data)
      : email = data['email'],
        fullName = data['full_name'],
        userRole = data['user_role'];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'user_role': userRole,
    };
  }
}
