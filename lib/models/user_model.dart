import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  //Usuario atual
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener)async {
    super.addListener(listener);

    await _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic>? userData,
      @required String? pass,
      @required VoidCallback? onSuccess,
      @required VoidCallback? onFail}) {
    isLoading = true;
    //print("Chegou no SignUP");
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData!["email"], password: pass!)
        .then(
      (auth) async {
        firebaseUser = auth.user!;

        await _saveUserData(userData);
        onSuccess!();
        isLoading = false;
        notifyListeners();
      },
    ).catchError(
      (e) {
        /*  print(e);
        print("Deu erro"); */
        onFail!();
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void signIn(
      {@required String? email,
      @required String? pass,
      @required VoidCallback? onSuccess,
      @required VoidCallback? onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email!, password: pass!)
        .then((auth) async {
      firebaseUser = auth.user!;

      await _loadCurrentUser();

      onSuccess!();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail!();
      isLoading = false;
      notifyListeners();
    });

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void signOut() async {
    await _auth.signOut();

    userData.clear();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    print("Chegou no save data");
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      //pegando usuario atual do firebase
      firebaseUser = _auth.currentUser;
     // print("primero if");
      if (firebaseUser != null) {
        //print("segundo if");
        if (userData["name"] == null) {
          //print("terceiro if");
          DocumentSnapshot docUser = await FirebaseFirestore.instance
              .collection("users")
              .doc(firebaseUser!.uid)
              .get();

          userData = docUser.data() as Map<String, dynamic>;
          notifyListeners();
          //print("finalizou");
          //print(userData);
        }
      }
      notifyListeners();
    }
  }
}
