import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String token;
  final String firstName;
  final String lastName;
  final String email;

  const UserEntity({
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  List<Object?> get props => [token, firstName, lastName, email];
}