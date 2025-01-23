import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jurni_test/data/constants.dart';
import 'package:jurni_test/data/models/user_data_model.dart';
import 'package:jurni_test/utils/pref_utils.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitial());

  Future<dynamic> updateUserDataOnFirebase({
    String? displayName,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? goals,
    String? preferences,
    String? activityLevel,
    String? cooking,
    num? age,
    num? weight,
  }) async {
    bool success = false;
    try {
      /// Here we know that user won't be null it's safe to use user here
      final user = FirebaseAuth.instance.currentUser!;
      emit(const UserDataLoading(isBusy: true));

      final request = {
        "uid": user.uid,
        if (displayName != null) "displayName": displayName,
        if (email != null) "email": email,
        if (photoUrl != null) "photoUrl": photoUrl,
        if (phoneNumber != null) "phoneNumber": phoneNumber,
        if (goals != null) "goals": goals,
        if (preferences != null) "preferences": preferences,
        if (activityLevel != null) "activityLevel": activityLevel,
        if (cooking != null) "cooking": cooking,
        if (age != null) "age": age,
        if (weight != null) "weight": weight,
      };

      final firestore = FirebaseFirestore.instance.collection(Constants.keyUsers).doc(user.uid);
      await firestore.set(request, SetOptions(merge: true));

      success = true;

      emit(const UserDataLoading(isBusy: false));

      if (success) {
        final oldData = PrefUtils().getString(Constants.firebaseUser);

        var oldUser = UserData.fromJson(jsonDecode(oldData));

        oldUser = oldUser.copyWith(
          displayName: displayName,
          email: email,
          photoUrl: photoUrl,
          phoneNumber: phoneNumber,
          activityLevel: activityLevel,
          age: age,
          cooking: cooking,
          goals: goals,
          preferences: preferences,
          weight: weight,
        );

        PrefUtils().saveString(Constants.firebaseUser, jsonEncode(oldUser));
        emit(UserDataSuccess(userData: oldUser));
      }
    } on FirebaseAuthException catch (e) {
      emit(const UserDataLoading(isBusy: false));
      print("FirebaseAuthException exception =====>>> $e");
      emit(UserDataFailed(error: e.message ?? "Something went wrong"));
    } catch (e, stacktrace) {
      emit(const UserDataLoading(isBusy: false));
      emit(UserDataFailed(error: e.toString()));
      print("createUser exception =====>>> $e");
      print("createUser exception stacktrace =====>>> $stacktrace");
    }
  }
}
