import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';

class FirebaseAuthentication with ChangeNotifier {
  FirebaseAuthentication() : isLoggedIn = false {
    isLoggedIn = auth.currentUser != null;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  bool isLoggedIn;

  Future<String> signInWithPassword({
    required final String email,
    required final String password,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      isLoggedIn = true;
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'failed';
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await auth.signInWithCredential(credential);
      isLoggedIn = true;
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    isLoggedIn = false;
  }

  Future<String> forgetPassword({required final String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> singUp({
    required final String email,
    required final String password,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await auth.currentUser!.sendEmailVerification();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}
