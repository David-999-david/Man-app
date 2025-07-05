import 'package:dio/dio.dart';
import 'package:user_auth/common/constant/api_url.dart';
import 'package:user_auth/core/network/dio_client.dart';
import 'package:user_auth/data/model/address/address_model.dart';

class AddressRemote {
  final Dio _dio = DioClient.dio;

  Future<AddressModel> createAddress(FormData form) async {
    try {
      final response = await _dio.post(ApiUrl.addAddress,
          data: form, options: Options(contentType: 'multipart/form-data'));

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map;
        return AddressModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception(
            'Error => status=${status}, message=${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response?.statusCode} : ${e.response?.data}');
    }
  }

  Future<List<AddressModel>> getAllAddress() async {
    try {
      final response = await _dio.get(ApiUrl.getAllAddress);

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['allAddress'] as List<dynamic>;

        return data
            .map((item) => AddressModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Error => status=$status, message => ${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception(
          '${e.response?.statusCode} : ${e.response?.data['error']}');
    }
  }

  Future<AddressModel> editAddress(int id, FormData form) async {
    try {
      final response = await _dio.put('${ApiUrl.updateAddress}$id',
          data: form, options: Options(contentType: 'multipart/form-data'));

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;

        return AddressModel.fromJson(data);
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception(
          '${e.response?.statusCode} : ${e.response?.data['error']}');
    }
  }

  Future<String> removeAddress(int id) async {
    try {
      final response = await _dio.delete('${ApiUrl.removeAddress}$id');

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['message'] as String;

        return data;
      } else {
        throw Exception(
            'Error : status=$status, message=${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception(
          '${e.response?.statusCode} : ${e.response?.data['error']}');
    }
  }
}
