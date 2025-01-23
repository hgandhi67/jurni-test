import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jurni_test/data/constants.dart';
import 'package:jurni_test/data/models/user_data_model.dart';
import 'package:jurni_test/utils/pref_utils.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<dynamic> createUser({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading(isBusy: true));
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(const AuthLoading(isBusy: false));

      if (userCredential.user != null && userCredential.user?.uid.isNotEmpty == true) {
        final user = userCredential.user!;
        final userData = UserData(
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
          uid: user.uid,
          phoneNumber: user.phoneNumber,
        );

        PrefUtils().saveBool(Constants.isLoggedIn, true);
        PrefUtils().saveString(Constants.firebaseUser, jsonEncode(userData));
        emit(AuthSuccess(user: userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      emit(const AuthLoading(isBusy: false));
      print("FirebaseAuthException exception =====>>> $e");
      if (e.code == 'weak-password') {
        emit(const AuthFailed(error: "The password provided is too weak"));
      } else if (e.code == 'email-already-in-use') {
        emit(const AuthFailed(error: "The account already exists for that email."));
      } else {
        emit(AuthFailed(error: e.message ?? "Something went wrong"));
      }
    } catch (e, stacktrace) {
      emit(const AuthLoading(isBusy: false));
      emit(AuthFailed(error: e.toString()));
      print("createUser exception =====>>> $e");
      print("createUser exception stacktrace =====>>> $stacktrace");
    }
  }

  Future<void> logout() async {
    PrefUtils().clearPreferenceAndDB();
    await FirebaseAuth.instance.signOut();
  }
}
