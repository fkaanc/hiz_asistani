import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../viewmodels/map_view_model.dart';
import '../views/records_screen.dart';

// Harita ekranı burada görüntüleniyor  
class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel()..initialize(),
      child: const MapScreenContent(),
    );
  }
}

// Harita içeriği burda görüntüleniyor
class MapScreenContent extends StatelessWidget {
  const MapScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          if (viewModel.currentPosition == null)
            const Center(child: CircularProgressIndicator())
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  viewModel.currentPosition!.latitude,
                  viewModel.currentPosition!.longitude,
                ),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                viewModel.setMapController(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: viewModel.markers,
              polylines: viewModel.polylines,
            ),
          SpeedDisplay(viewModel: viewModel),
          // Kayıtlar butonu - sol üstte
          Positioned(
            top: 50,
            left: 16,
            child: FloatingActionButton(
              onPressed: () {
                if (viewModel.corridorRecords.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Henüz koridor kaydı bulunmuyor'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordsScreen(
                        records: viewModel.corridorRecords,
                      ),
                    ),
                  );
                }
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.history),
            ),
          ),
        ],
      ),
    );
  }
}

class SpeedDisplay extends StatelessWidget {
  final MapViewModel viewModel;

  const SpeedDisplay({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aktif Koridor Bilgisi
          if (viewModel.isInCorridor && viewModel.activeEdsCorridor != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    viewModel.activeCorridorName ?? 'EDS Koridoru',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          // Uyarı mesajı
          if (viewModel.showSpeedWarning && viewModel.isInCorridor)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Süratinizi Düşürün!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          // Mevcut hız göstergesi
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${viewModel.currentSpeed.toStringAsFixed(1)} km/h',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Anlık Hız'),
                if (viewModel.isInCorridor) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${viewModel.corridorAverageSpeed.toStringAsFixed(1)} km/h',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: viewModel.corridorAverageSpeed > 
                          (viewModel.activeEdsCorridor?.speedLimit ?? 0)
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  Text(
                    'Koridor Ortalama Hız\n'
                    'Limit: ${viewModel.activeEdsCorridor?.speedLimit ?? 0} km/h',
                    textAlign: TextAlign.start,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
} 