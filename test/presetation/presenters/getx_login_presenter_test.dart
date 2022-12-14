import 'package:GreencityTeam/domain/entities/entities.dart';
import 'package:GreencityTeam/domain/helpers/helpers.dart';
import 'package:GreencityTeam/domain/usecases/usecases.dart';

import 'package:GreencityTeam/presetation/presenters/presenters.dart';
import 'package:GreencityTeam/presetation/protocols/protocols.dart';
import 'package:GreencityTeam/ui/helpers/helpers.dart';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation{}
class AuthenticationSpy extends Mock implements Authentication{}
class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount{}

void main(){
  GetxLoginPresenter sut;
  AuthenticationSpy authentication;
  ValidationSpy validation;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall(String field) =>
      when(validation.validate(field: field == null ? anyNamed("field") : field, value: anyNamed("value")));

  void mockValidation({String field, ValidationError value}){
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication(){
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockAuthenticationError(DomainError error){
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() => when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccount(){
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp((){
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(validation: validation, authentication: authentication, saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockAuthentication();
  });

  test("Should call Validation with correct email", (){
    sut.validateEmail(email);

    verify(validation.validate(field: "email", value: email)).called(1);
  });

  test("Should emit invalidFieldError if email is invalid", (){
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Should emit requiredFieldError if email is empty", (){
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Should emit null if validation succeds", (){

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Should call Validation with correct password", (){
    sut.validatePassword(password);

    verify(validation.validate(field: "password", value: password)).called(1);
  });

  test("Should emit requiredFieldError if password is empty", (){
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Should emit null if validation success", (){
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Should disable form button if any field is invalid", (){
    mockValidation(field: "email", value: ValidationError.invalidField);

    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test("Should enable form button if all fields are valid", () async{

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
    
    sut.validateEmail(email);

    await Future.delayed(Duration.zero);

    sut.validatePassword(password);
  });

  test("Should call Authentication with correct values", () async{

    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test("Should emit correct events on Authentication success", () async{

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test("Should emit correct events on InvalidCredentialsError", () async{
    mockAuthenticationError(DomainError.invalidCredentials);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidCredentials)));

    await sut.auth();
  });

  test("Should emit correct events on UnexpectedError", () async{
    mockAuthenticationError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.auth();
  });

  test("Should call SaveCurrentAccount with correct value", () async{

    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test("Should emit UnexpectedError if SaveCurrentAccount fails", () async{
    mockSaveCurrentAccount();

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.auth();
  });

  test("Should change page on success", () async{

    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/surveys")));

    await sut.auth();
  });

}