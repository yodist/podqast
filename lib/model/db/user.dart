import 'dart:convert';

class User {
  final String email;
  final String fullName;
  final String userRole;
  List<dynamic>? subscriptions;

  User(
      {required this.fullName,
      required this.email,
      this.userRole = 'User',
      this.subscriptions = const []});

  User.fromData(Map<String, dynamic> data)
      : email = data['email'],
        fullName = data['full_name'],
        userRole = data['user_role'],
        subscriptions = data['subscriptions'] as List<dynamic>;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'user_role': userRole,
      'subscriptions': subscriptions
    };
  }
}
