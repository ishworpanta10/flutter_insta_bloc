import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final String code;

  //if no code and message is passed default is empty string;
  const Failure({this.message = "", this.code = ""});

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [message, code];
}
