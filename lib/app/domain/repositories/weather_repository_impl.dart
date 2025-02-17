import 'dart:developer';

import 'package:weather/app/domain/requests/location_requests.dart';
import 'package:weather/app/domain/requests/weather_request.dart';
import 'package:weather/app/domain/response/location_response.dart';
import 'package:weather/app/domain/response/weather_response.dart';

import '../../data/data_sources/remote/WeatherRepository.dart';
import '../../shared/core/network/dio_manager.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  final DioManager _dio;
  WeatherRepositoryImpl(this._dio);

  @override
  Future<WeatherResponse?> getWeather(final WeatherRequest data) async {
    log('getWeather called'); // Log at the start
    WeatherResponse? res;
    try {
      log('Sending WeatherRequest: ${data.toJson().toString()}');
      await _dio.get('/data/3.0/onecall?', json: data.toJson()).then((response) {
        log('Received WeatherResponse: ${response.data}');
        if (response.data != null) {
          res = WeatherResponse.fromJson(response.data);
        } else {
          log('response.data == null');
        }
      });
    } catch (e) {
      log('Error during getWeather: $e');
    }
    return res;
  }

  @override
  Future<LocationResponse?> getLocation(final LocationRequest data) async {
    LocationResponse? res;
    try {
      // Print the request being sent
      log('Sending LocationRequest: ${data.toJson().toString()}');

      await _dio
          .get(
        '/geo/1.0/reverse',
        json: data.toJson(),
      )
          .then((response) {
        if (response.data != null) {
          res = (response.data as List)
              .map((e) => LocationResponse.fromJson(e))
              .toList()[0];
          print('LocationResponse: $res');
        } else {
          log('response.data == null');
        }
      });
    } catch (e) {
      log(e.toString());
    }
    return res;
  }

}
