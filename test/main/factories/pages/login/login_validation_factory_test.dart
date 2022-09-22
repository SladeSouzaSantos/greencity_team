import 'package:GreencityTeam/main/factories/factories.dart';
import 'package:GreencityTeam/validation/validators/validators.dart';
import 'package:test/test.dart';

void main() {
  test("Should the correct validations", () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation("email"),
      EmailValidation("email"),
      RequiredFieldValidation("password"),
    ]);

  });
}
