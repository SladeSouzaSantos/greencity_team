import 'package:equatable/equatable.dart';
import '../../presetation/protocols/validation.dart';
import '../protocols/protocols.dart';
import '../../presetation/protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation{
  final String field;

  List get props => [field];

  RequiredFieldValidation(this.field);

  ValidationError validate(String value){
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

}