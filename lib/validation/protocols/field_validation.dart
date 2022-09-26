import '../../presetation/protocols/protocols.dart';

abstract class FieldValidation{
  String get field;
  ValidationError validate(String value);
}