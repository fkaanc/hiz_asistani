// Koridor değişkenleri 
class CorridorRecord {
  final String corridorName;     // Koridor adı
  final DateTime entryTime;      // Koridora giriş zamanı
  final DateTime exitTime;       // Koridordan çıkış zamanı
  final double averageSpeed;     // Koridor boyunca ortalama hız
  final double maxSpeed;         // Koridor boyunca maksimum hız
  final double distance;         // Koridorun boyu (mesafe)
  final int speedLimit;          // Koridor boyunca uyulması gerekenhız limiti
  final bool exceededLimit;      // Koridorda hız limitini aşım durumu (true false)

  CorridorRecord({
    required this.corridorName,
    required this.entryTime,
    required this.exitTime,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.distance,
    required this.speedLimit,
    required this.exceededLimit,
  });

  String get formattedEntryTime => 
      '${entryTime.hour}:${entryTime.minute}:${entryTime.second}';
  
  String get formattedExitTime => 
      '${exitTime.hour}:${exitTime.minute}:${exitTime.second}';
  
  String get duration {
    final difference = exitTime.difference(entryTime);
    return '${difference.inMinutes} dk ${difference.inSeconds % 60} sn';
  }
} 