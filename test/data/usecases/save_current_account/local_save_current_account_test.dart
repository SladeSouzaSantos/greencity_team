import 'package:GreencityTeam/data/cache/cache.dart';
import 'package:GreencityTeam/data/usecases/usecases.dart';
import 'package:GreencityTeam/domain/entities/entities.dart';
import 'package:GreencityTeam/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage{}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  setUp((){
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  void mockError(){
    when(saveSecureCacheStorage.saveSecure(key: anyNamed("key"), value: anyNamed("value"))).thenThrow(Exception());
  }

  test("Should call SaveSecureCacheStorage with correct values", () async{
    await sut.save(account);

    verify(saveSecureCacheStorage.saveSecure(key: "token", value: account.token));
  });

  test("Should throw UnexpectedError if SaveSecureCacheStorage throws", () async{
    mockError();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
