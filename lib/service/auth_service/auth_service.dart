import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class AuthService{
  Future register({required String email, required String pass, required String name, required String type})async{
    var createUser = await auth.createUserWithEmailAndPassword(email: email, password: pass);
    print('istenne tip: ${createUser.runtimeType}');
    User? user = auth.currentUser;
    user!.updateDisplayName(name);
    user.sendEmailVerification();
    await firestore.collection('users').doc(user.uid).set({
      'user_type': type,
      'email': email,
      'name': name,
      'uid': user.uid
    });
    return createUser;
  }

  Future login({required String email, required String pass})async{
    await auth.signInWithEmailAndPassword(email: email, password: pass).then((value){
      return value;
    });
  }
}