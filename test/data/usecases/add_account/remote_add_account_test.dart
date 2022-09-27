
import 'package:GreencityTeam/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:GreencityTeam/data/http/http.dart';
import 'package:GreencityTeam/data/usecases/usecases.dart';
import 'package:GreencityTeam/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient{}

void main(){

  HttpClientSpy httpClient;
  String url;
  RemoteAddAccount sut;
  AddAccountParams params;

  setUp((){
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
  });

  test("Should call HttpClient with correct values", () async{
    await sut.add(params);

    verify(httpClient.request(
        url: url,
        method: "post",
        body: {
          "name" : params.name,
          "email" : params.email,
          "password" : params.password,
          "passwordConfirmation" : params.passwordConfirmation,

        }
    ));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async{
    when(httpClient.request(url: anyNamed("url"), method: anyNamed("method"), body: anyNamed("body")))
        .thenThrow(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async{
    when(httpClient.request(url: anyNamed("url"), method: anyNamed("method"), body: anyNamed("body")))
        .thenThrow(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
