import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podqast/model/db/user.dart';
import 'package:podqast/model/response.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<Response> createUser(User user) async {
    Query query =
        _usersCollectionReference.where('email', isEqualTo: user.email);
    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.size > 0)
      return Response(success: false, message: 'The data is already exists');
    try {
      await _usersCollectionReference.doc(user.email).set(user.toJson());
      return Response(success: true);
    } catch (e) {
      return Response(success: false, error: e);
    }
  }
}
