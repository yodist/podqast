import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:podqast/model/db/user.dart' as my;
import 'package:podqast/model/response.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<Response> createUser(my.User user) async {
    Query query =
        _usersCollectionReference.where('email', isEqualTo: user.email);
    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.size > 0) {
      var userSnap = querySnapshot.docs.first.data();
      return Response(
          success: true, message: 'The data is already exists', data: userSnap);
    }

    try {
      await _usersCollectionReference.doc(user.email).set(user.toJson());
      return Response(success: true, data: user);
    } catch (e) {
      return Response(success: false, error: e);
    }
  }

  Future<Response> addSubscriptionsToUser(String podcastId) async {
    DocumentReference docRef = _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser!.email!);

    try {
      DocumentSnapshot docSnap = await docRef.get();
      var data = docSnap.data() as Map<String, dynamic>;
      if ((data['subscriptions'] as List<dynamic>).contains(podcastId)) {
        await docRef.update({
          "subscriptions": FieldValue.arrayRemove([podcastId])
        });
      } else {
        await docRef.update({
          "subscriptions": FieldValue.arrayUnion([podcastId])
        });
      }

      docSnap = await docRef.get();
      data = docSnap.data() as Map<String, dynamic>;

      return Response(success: true, data: data);
    } catch (e) {
      return Response(success: false, error: e);
    }
  }
}
