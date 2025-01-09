import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/eds_corridor.dart';
import '../services/location_service.dart';
import '../services/maps_service.dart';
import 'package:geolocator/geolocator.dart';
import '../models/corridor_record.dart';

class MapViewModel extends ChangeNotifier {
  final MapsService _mapsService = MapsService();
  Position? currentPosition;
  Position? lastPosition;
  GoogleMapController? _mapController;

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  double currentSpeed = 0.0;
  final List<double> speedReadings = [];
  double maxSpeedInCorridor = 0.0;
  bool showSpeedWarning = false;

  EdsCorridor? activeEdsCorridor;
  DateTime? corridorEntryTime;
  double corridorAverageSpeed = 0.0;
  bool isInCorridor = false;
  double corridorDistance = 0.0;
  double totalDistanceInCorridor = 0.0;

  final List<CorridorRecord> corridorRecords = [];

  final List<Map<String, dynamic>> edsCorridors = [
    {
      'baslangic': const LatLng(38.6898481375528, 35.49409576905717),
      'bitis': const LatLng(38.69143986880704, 35.493324317571757),
      'hizLimiti': 10,
      'name': 'NTAL EDS',
    },
    {
      'baslangic': const LatLng(38.63534424026343, 35.51741775315374),
      'bitis': const LatLng(38.681808151328106, 35.49836358754165),
      'hizLimiti': 70,
      'name': 'Hisarcık EDS',
    },
    {
      'baslangic': const LatLng(38.690284840293934, 35.49087872861636),
      'bitis': const LatLng(38.69208986842661, 35.48934572861637),
      'hizLimiti': 50,
      'name': 'Paşalı EDS',
    },
  ];

  Future<void> initialize() async {
    await checkPermissions();
    startLocationTracking();
    drawEdsZones();
  }

  Future<void> checkPermissions() async {
    if (await LocationService.checkPermissions()) {
      await getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      currentPosition = await LocationService.getCurrentLocation();
      notifyListeners();
    } catch (e) {
      debugPrint('Konum alınamadı: $e');
    }
  }

  void startLocationTracking() {
    LocationService.getLocationStream().listen((Position position) {
      if (isInCorridor && lastPosition != null) {
        double incrementalDistance = Geolocator.distanceBetween(
          lastPosition!.latitude,
          lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        
        if (incrementalDistance < 30) { // 30 metre/saniye = 108 km/saat
          totalDistanceInCorridor += incrementalDistance;
        }
      }
      
      lastPosition = position;
      currentPosition = position;
      double newSpeed = (position.speed * 3.6);
      currentSpeed = newSpeed < 0.5 ? 0.0 : newSpeed;
      
      speedReadings.add(currentSpeed);
      if (speedReadings.length > 10) {
        speedReadings.removeAt(0);
      }
      
      checkIfInEdsZone();
      if (isInCorridor) {
        _updateCorridorSpeed();
        _updateCameraPosition();
      }
      notifyListeners();
    });
  }

  Future<void> drawEdsZones() async {
    for (var i = 0; i < edsCorridors.length; i++) {
      var koridor = edsCorridors[i];
      var koridorAdi = koridor['name'] ?? 'EDS Koridoru';

      // Koridorun detaylarını al
      var routeDetails = await _mapsService.getRouteDetails(
        koridor['baslangic'],
        koridor['bitis'],
      );

      // Koridorun mesafesini kaydet
      koridor['mesafe'] = routeDetails['distance'];
      var mesafeKm = (routeDetails['distance'] / 1000).toStringAsFixed(1);

      // Başlangıç marker'ı (koridorun başlangıç noktası)
      markers.add(
        Marker(
          markerId: MarkerId('eds_start_$i'),
          position: koridor['baslangic'],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: '$koridorAdi (Başlangıç)',
            snippet: 'Hız Limiti: ${koridor['hizLimiti']} km/h',
          ),
        ),
      );

      // Bitiş marker'ı (koridorun bitiş noktası)
      markers.add(
        Marker(
          markerId: MarkerId('eds_end_$i'),
          position: koridor['bitis'],
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: '$koridorAdi (Bitiş)',
            snippet: 'Hız Limiti: ${koridor['hizLimiti']} km/h',
          ),
        ),
      );

      if (routeDetails['points'].isNotEmpty) {
        polylines.add(
          Polyline(
            polylineId: PolylineId('eds_line_$i'),
            points: routeDetails['points'],
            color: Colors.red,
            width: 5,
          ),
        );
      }
    }
    notifyListeners();
  }

  void checkIfInEdsZone() {
    if (currentPosition == null) return;

    for (var koridor in edsCorridors) {
      double distanceToStart = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        koridor['baslangic'].latitude,
        koridor['baslangic'].longitude,
      );

      if (distanceToStart < 100) {
        if (activeEdsCorridor == null) {
          _enterCorridor(koridor);
          notifyListeners();
        }
        return;
      }

      double distanceToEnd = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        koridor['bitis'].latitude,
        koridor['bitis'].longitude,
      );

      if (isInCorridor && distanceToEnd < 100) {
        _exitCorridor();
        return;
      }
    }
  }

  Future<void> _highlightActiveRoute(Map<String, dynamic> koridor) async {
    // Önceki rotaları silinmiş renkle göster
    for (var polyline in polylines) {
      polylines.remove(polyline);
      polylines.add(
        Polyline(
          polylineId: polyline.polylineId,
          points: polyline.points,
          color: Colors.grey.withOpacity(0.5),
          width: 3,
        ),
      );
    }

    // Aktif rotayı çiz
    var routeDetails = await _mapsService.getRouteDetails(
      koridor['baslangic'],
      koridor['bitis'],
    );

    if (routeDetails['points'].isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('active_route'),
          points: routeDetails['points'],
          color: Colors.blue,
          width: 6,
          patterns: [
            PatternItem.dash(20),
            PatternItem.gap(10),
          ],
        ),
      );
    }
    notifyListeners();
  }


  void _resetRoutes() {
    drawEdsZones();
  }

  void _updateCorridorSpeed() {
    if (corridorEntryTime == null || currentPosition == null || activeEdsCorridor == null) return;

    double hours = DateTime.now().difference(corridorEntryTime!).inSeconds / 3600;
    double distance = totalDistanceInCorridor / 1000;
    corridorAverageSpeed = distance / hours;
    
    // Hız limiti kontrolü burada
    showSpeedWarning = corridorAverageSpeed > activeEdsCorridor!.speedLimit;
    notifyListeners();
  }

  void _calculateAverageSpeed() {
    if (corridorEntryTime == null || currentPosition == null || activeEdsCorridor == null) return;

    double hours = DateTime.now().difference(corridorEntryTime!).inSeconds / 3600;
    double distance = totalDistanceInCorridor / 1000;
    corridorAverageSpeed = distance / hours;
    notifyListeners();
  }

  String? get activeCorridorName {
    if (!isInCorridor || activeEdsCorridor == null) return null;
    
    for (var koridor in edsCorridors) {
      if (koridor['baslangic'].latitude == activeEdsCorridor!.startLat &&
          koridor['baslangic'].longitude == activeEdsCorridor!.startLng) {
        return koridor['name'] ?? 'EDS Koridoru';
      }
    }
    return 'EDS Koridoru';
  }

  // Koridor çıkışında kayıt oluştur
  void _saveCorridorRecord() {
    if (corridorEntryTime == null || activeEdsCorridor == null) return;

    corridorRecords.add(
      CorridorRecord(
        corridorName: activeCorridorName ?? 'EDS Koridoru',
        entryTime: corridorEntryTime!,
        exitTime: DateTime.now(),
        averageSpeed: corridorAverageSpeed,
        maxSpeed: maxSpeedInCorridor,
        distance: totalDistanceInCorridor,
        speedLimit: activeEdsCorridor!.speedLimit,
        exceededLimit: corridorAverageSpeed > activeEdsCorridor!.speedLimit,
      ),
    );

    // Kayıt sonrası değerleri sıfırla
    maxSpeedInCorridor = 0.0;
    notifyListeners();
  }

  // Hız güncellemelerinde maksimum hızı kontrol et
  void _updateSpeed(Position position) {
    currentSpeed = position.speed * 3.6; // m/s'den km/h'ye çevir
    if (isInCorridor && currentSpeed > maxSpeedInCorridor) {
      maxSpeedInCorridor = currentSpeed;
    }
    notifyListeners();
  }

  // Koridor çıkışında kayıt oluştur ve değerleri sıfırla
  void _exitCorridor() {
    _saveCorridorRecord();
    isInCorridor = false;
    activeEdsCorridor = null;
    corridorEntryTime = null;
    totalDistanceInCorridor = 0;
    corridorAverageSpeed = 0;
    _resetRoutes();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  // Koridora girişte çağrılacak
  void _enterCorridor(Map<String, dynamic> koridor) {
    activeEdsCorridor = EdsCorridor.fromMap(koridor);
    corridorEntryTime = DateTime.now();
    isInCorridor = true;
    totalDistanceInCorridor = 0.0;
    lastPosition = currentPosition;
    _highlightActiveRoute(koridor);
    _updateCameraPosition();
  }

  // Konum değişirken ekran odaklanma pozisyonunu güncelleme
  void _updateCameraPosition() {
    if (_mapController != null && currentPosition != null && isInCorridor) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentPosition!.latitude,
              currentPosition!.longitude,
            ),
            zoom: 17.0,
          ),
        ),
      );
    }
  }
} 