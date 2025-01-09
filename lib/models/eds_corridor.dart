class EdsCorridor {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final int speedLimit;
  final double distance; // metre cinsinden mesafe

  EdsCorridor({
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.speedLimit,
    required this.distance,
  });

  factory EdsCorridor.fromMap(Map<String, dynamic> map) {
    return EdsCorridor(
      startLat: map['baslangic'].latitude,
      startLng: map['baslangic'].longitude,
      endLat: map['bitis'].latitude,
      endLng: map['bitis'].longitude,
      speedLimit: map['hizLimiti'],
      distance: map['mesafe']?.toDouble() ?? 0.0,
    );
  }
} 