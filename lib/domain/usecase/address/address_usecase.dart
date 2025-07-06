import 'package:dio/dio.dart';
import 'package:user_auth/data/model/address/address_model.dart';
import 'package:user_auth/domain/repository/address/address_repository.dart';

class AddressUsecase {
  Future<AddressModel> createAddress(FormData form) async {
    return await AddressRepository().createAddress(form);
  }

  Future<List<AddressModel>> getAllAddress() async {
    return await AddressRepository().getAllAddress();
  }

  Future<AddressModel> editAddress(int id, FormData form) async {
    return await AddressRepository().editAddress(id, form);
  }

  Future<String> removeAddress(int id) async {
    return await AddressRepository().removeAddress(id);
  }

  Future<List<ReturnTestAddress>> createMany(List<TestAddress> items) async {
    return await AddressRepository().createMany(items);
  }
}
