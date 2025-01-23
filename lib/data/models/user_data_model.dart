import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  const UserData({
    this.displayName,
    this.email,
    this.photoUrl,
    this.uid,
    this.phoneNumber,
    this.goals,
    this.preferences,
    this.activityLevel,
    this.cooking,
    this.age,
    this.weight,
    this.metadata,
  });

  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? uid;
  final String? phoneNumber;
  final String? goals;
  final String? preferences;
  final String? activityLevel;
  final String? cooking;
  final num? age;
  final num? weight;
  final Metadata? metadata;

  UserData copyWith({
    String? displayName,
    String? email,
    String? photoUrl,
    String? uid,
    String? phoneNumber,
    String? goals,
    String? preferences,
    String? activityLevel,
    String? cooking,
    num? age,
    num? weight,
    Metadata? metadata,
  }) {
    return UserData(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      goals: goals ?? this.goals,
      preferences: preferences ?? this.preferences,
      activityLevel: activityLevel ?? this.activityLevel,
      cooking: cooking ?? this.cooking,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      metadata: metadata ?? this.metadata,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      displayName: json["displayName"],
      email: json["email"],
      photoUrl: json["photoURL"],
      uid: json["uid"],
      phoneNumber: json["phoneNumber"],
      goals: json["goals"],
      preferences: json["preferences"],
      activityLevel: json["activityLevel"],
      cooking: json["cooking"],
      age: json["age"],
      weight: json["weight"],
      metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "email": email,
        "photoURL": photoUrl,
        "uid": uid,
        "phoneNumber": phoneNumber,
        "goals": goals,
        "preferences": preferences,
        "activityLevel": activityLevel,
        "cooking": cooking,
        "age": age,
        "weight": weight,
        "metadata": metadata?.toJson(),
      };

  @override
  String toString() {
    return "$displayName, $email, $photoUrl, $uid, $phoneNumber, $goals, $preferences, $activityLevel, $cooking, $age, $weight, $metadata, ";
  }

  @override
  List<Object?> get props => [
        displayName,
        email,
        photoUrl,
        uid,
        phoneNumber,
        goals,
        preferences,
        activityLevel,
        cooking,
        age,
        weight,
        metadata,
      ];
}

class Metadata extends Equatable {
  Metadata({required this.json});

  final Map<String, dynamic> json;

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(json: json);
  }

  Map<String, dynamic> toJson() => {};

  @override
  String toString() {
    return "";
  }

  @override
  List<Object?> get props => [];
}
