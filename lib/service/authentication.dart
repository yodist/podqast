import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:podqast/model/db/user.dart' as my;
import 'package:podqast/model/response.dart';
import 'package:podqast/providers/main_provider.dart';
import 'package:podqast/service/user_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<my.User?> signInWithGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
  final User? user = userCredential.user;
  my.User? myUser;

  if (user != null) {
    // assert(user.isAnonymous);
    // assert(await user.getIdToken() != null);
    final User? currentUser = _auth.currentUser;
    assert(currentUser != null && currentUser.uid == user.uid);
    if (currentUser != null) {
      UserService _userService = UserService();
      Response response = await _userService.registerUser(
          email: currentUser.email!, fullName: currentUser.displayName!);
      myUser = my.User.fromData(response.data);
    }
  }

  return myUser;
}

// Now can use FirebaseAuth.instance.signOut()
@deprecated
void signOutGoogle() async {
  await googleSignIn.signOut();
}
