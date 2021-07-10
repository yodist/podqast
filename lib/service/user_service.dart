import 'package:podqast/model/db/user.dart';
import 'package:podqast/model/response.dart';
import 'package:podqast/service/firestore_service.dart';

class UserService {
  FirestoreService _firestoreService = FirestoreService();

  Future<Response> registerUser(
      {required String email, required String fullName}) async {
    User user = User(email: email, fullName: fullName);

    return await _firestoreService.createUser(user);
  }
}
