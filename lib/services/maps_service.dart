import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../config/api_keys.dart';

// Google Maps API ve bağlantılar burada
class MapsService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  final String _apiKey = ApiKeys.googleMapsApiKey;

  // Başlangıç ve bitiş noktaları arası rota oluşturma
  Future<Map<String, dynamic>> getRouteDetails(LatLng start, LatLng end) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${start.latitude},${start.longitude}',
          'destination': '${end.latitude},${end.longitude}',
          'key': _apiKey,
        },
      );

      if (response.data['status'] == 'OK') {
        var route = response.data['routes'][0]['legs'][0];
        return {
          'distance': route['distance']['value'], // metre cinsinden mesafe
          'points': _decodePolyline(route['overview_polyline']['points']),
        };
      }
      return {'distance': 0, 'points': <LatLng>[]};
    } catch (e) {
      return {'distance': 0, 'points': <LatLng>[]};
    }
  }

  //  Başlangıç ve bitiş noktaları arası rota oluşturma burada (polyline ile)
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }
} 