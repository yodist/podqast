import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:podqast/service/user_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User?> signInWithGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);

  final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
  final User? user = userCredential.user;

  if (user != null) {
    // assert(user.isAnonymous);
    // assert(await user.getIdToken() != null);
    final User? currentUser = _auth.currentUser;
    assert(currentUser != null && currentUser.uid == user.uid);
    if (currentUser != null) {
      UserService _userService = UserService();
      _userService.registerUser(
          email: currentUser.email!, fullName: currentUser.displayName!);
    }
  }

  return user;
}

// Now can use FirebaseAuth.instance.signOut()
@deprecated
void signOutGoogle() async {
  await googleSignIn.signOut();
}
