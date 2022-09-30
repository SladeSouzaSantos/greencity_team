import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable{
  final String token;

  AccountEntity(this.token);

  factory AccountEntity.fromJson(Map json) => AccountEntity(json['accessToken']);

  @override
  // TODO: implement props
  List get props => [token];
}