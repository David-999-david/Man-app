import 'package:dio/dio.dart';
import 'package:user_auth/data/model/address/address_model.dart';
import 'package:user_auth/data/remote/address/address_remote.dart';

class AddressRepository {
  Future<AddressModel> createAddress(FormData form) {
    return AddressRemote().createAddress(form);
  }
}
