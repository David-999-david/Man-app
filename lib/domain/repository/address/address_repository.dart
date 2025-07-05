import 'package:dio/dio.dart';
import 'package:user_auth/data/model/address/address_model.dart';
import 'package:user_auth/data/remote/address/address_remote.dart';

class AddressRepository {
  Future<AddressModel> createAddress(FormData form) {
    return AddressRemote().createAddress(form);
  }

  Future<List<AddressModel>> getAllAddress() {
    return AddressRemote().getAllAddress();
  }

  Future<AddressModel> editAddress(int id, FormData form) {
    return AddressRemote().editAddress(id, form);
  }

  Future<String> removeAddress(int id) {
    return AddressRemote().removeAddress(id);
  }
}
