part of 'user_data_cubit.dart';

sealed class UserDataState extends Equatable {
  const UserDataState();
}

final class UserDataInitial extends UserDataState {
  @override
  List<Object> get props => [];
}

final class UserDataLoading extends UserDataState {
  final bool isBusy;

  const UserDataLoading({required this.isBusy});

  @override
  List<Object> get props => [isBusy];
}

final class UserDataSuccess extends UserDataState {
  final UserData userData;

  const UserDataSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

final class UserDataFailed extends UserDataState {
  final String error;

  const UserDataFailed({required this.error});

  @override
  List<Object> get props => [error];
}
