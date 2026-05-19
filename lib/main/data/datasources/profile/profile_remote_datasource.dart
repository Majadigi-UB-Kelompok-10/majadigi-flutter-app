import 'package:majadigi_mobile_rebuild/main/data/datasources/decompression.dart';
import 'package:majadigi_mobile_rebuild/main/data/models/dto/profile/profile_dto.dart';
import 'package:majadigi_mobile_rebuild/main/data/datasources/remote_config.dart';
import 'package:dio/dio.dart';
import 'package:zstandard/zstandard.dart';

/// Represent the Contract for Profile Remote Datasource.
/// Uses Public API Gateway
abstract class ProfileRemoteDatasource {
  Future<ProfileDto> getProfileFromNetwork();
}

/// Represent the Profile Remote Datasource Implementation
class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final Dio dio;
  final Zstandard? zstandard;
  ProfileRemoteDatasourceImpl({required this.dio, this.zstandard}) {
    dio.options.baseUrl = baseUrl;
  }

  @override
  Future<ProfileDto> getProfileFromNetwork() async {
    final response = await dio.get('/user/auth/me');
    final data = await cleanupData(zstandard: zstandard, response: response);
    return ProfileDto.fromJson(data);
  }
}
