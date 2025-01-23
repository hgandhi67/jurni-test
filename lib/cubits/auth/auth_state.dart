part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  final bool isBusy;

  const AuthLoading({required this.isBusy});

  @override
  List<Object> get props => [isBusy];
}

final class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthFailed extends AuthState {
  final String error;

  const AuthFailed({required this.error});

  @override
  List<Object> get props => [error];
}
