import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geocoding/geocoding.dart';
import 'package:weather/app/data/data_sources/local/prefrancemanager.dart';
import 'package:weather/app/data/data_sources/remote/WeatherRepository.dart';
import 'package:weather/app/domain/entities/location_model.dart';
import 'package:weather/app/domain/requests/location_requests.dart';
import 'package:weather/app/domain/requests/weather_request.dart';
import 'package:weather/app/domain/response/location_response.dart';
import 'package:weather/app/domain/response/weather_response.dart';
import 'package:weather/app/shared/constant/app_value.dart';
import 'package:weather/app/shared/core/base/baseviewmodel.dart';
import 'package:weather/app/shared/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:permission_handler/permission_handler.dart';

class SplashViewModel extends BaseViewModel {
  PreferenceManager preferenceManager;
  WeatherRepository weatherRepository;

  SplashViewModel(this.preferenceManager, this.weatherRepository);
  void init(void Function() goRouterFun) async {
    log('Initializing SplashViewModel');

    await getCurrentLocation();
    await getWeather();
    log('Navigating to the main view.');
    goRouterFun();
  }


  Future<void> getWeather() async {
    try {
      log('Fetching weather data');
      final String locationPrefs = await preferenceManager.getCurrentLocation();
      final LocationModel location;
      if (locationPrefs.isEmpty) {
        log('Using default location');
        location = AppValues.defaultLocation;
      } else {
        location = LocationModel.fromJson(jsonDecode(locationPrefs));
      }

      final WeatherRequest data = WeatherRequest(
          lat: location.latitude,
          lon: location.longitude,
          lang: getLanguageCode(),
          appid: AppValues.apiKey);

      final WeatherResponse? weather = await weatherRepository.getWeather(data);
      if (weather != null) {
        log('Weather data fetched: ${weather.toJson()}');
        await preferenceManager.setLastWeather(jsonEncode(weather.toJson()));
      } else {
        log('Failed to fetch weather data.');
      }
    } catch (e) {
      log('Error in getWeather: $e');
    }
  }

  ///(TRUE, FALSE)]
  ///[check permission]
  ///[if app don't have permission request it]
  ///[change value of enabled if location permission is denied][from permission handler]
  ///[get current location from geolocator and accurecy]
  ///[translate latitude and longitude coordinates into an address]
  ///[save location in location instance]
  ///[weatherRepository.getLocation]
  ///[check locationResponse?.localNames]
  ///[set location in shared prefs]

  Future<void> getCurrentLocation() async {
    LocationModel? location;
    try {
      bool enabled;
      log('Checking location permission');
      if (kIsWeb) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          permission = await Geolocator.requestPermission();
        }
        enabled = permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever;
      } else {
        enabled = await Permission.location.request().isGranted;
      }

      if (enabled) {
        log('Location permission granted');
        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        log('Position fetched: $position');
        // Fetching location details logic here...
      } else {
        log('Location permission not granted.');
      }
    } catch (e) {
      log('Error fetching current location: $e');
    }
  }

  _getCityByLang(LocalNames localNames) {
    switch (getLanguageCode()) {
      case AppValues.langCodeUk:
        return localNames.uk;
      default:
        return localNames.en;
    }
  }
}
