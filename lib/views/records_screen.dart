import 'package:flutter/material.dart';
import '../models/corridor_record.dart';

// Eski EDS koridorlarının kayıtlarını görüntüleme (sol üst köşedeki buton)
class RecordsScreen extends StatelessWidget {
  final List<CorridorRecord> records;

  const RecordsScreen({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Eski EDS koridorlarının kayıtların detaylarını görüntüleme 
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koridor Kayıtları'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.corridorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Giriş: ${record.formattedEntryTime}'),
                  Text('Çıkış: ${record.formattedExitTime}'),
                  Text('Süre: ${record.duration}'),
                  Text('Mesafe: ${(record.distance / 1000).toStringAsFixed(2)} km'),
                  Text('Ortalama Hız: ${record.averageSpeed.toStringAsFixed(1)} km/h'),
                  Text('Hız Limiti: ${record.speedLimit} km/h'),
                  if (record.exceededLimit)
                    const Text(
                      'Hız Limiti Aşıldı!',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 