import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkında'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hız Asistanı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Versiyon: 1.0',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Giriş',
              'Hız Asistanı projesi, sürücülere EDS (Elektronik Denetleme Sistemi) hız koridorlarında '
              'hız sınırlarını aşmaları durumunda uyarı vererek trafik güvenliğini artırmayı amaçlayan '
              'bir mobil uygulamadır. Flutter ile geliştirilmiş olup, GPS tabanlı veri takibi ve '
              'Google Maps API entegrasyonu kullanmaktadır.',
            ),
            _buildSection(
              'Nasıl Çalışır?',
              '• Koridor başlangıcında GPS izni verilmeli\n'
              '• Mobil veri açık olmalı\n'
              '• Koridora girişte otomatik hız hesaplama başlar\n'
              '• Koridor boyunca ortalama hız takip edilir\n'
              '• Hız limiti aşımında görsel uyarı verilir\n'
              '• Koridor çıkışında kayıt otomatik oluşturulur',
            ),
            _buildSection(
              'Önemli Notlar',
              '• GPS sinyali zayıf bölgelerde veri doğruluğu etkilenebilir\n'
              '• Uygulamanın doğru çalışması için konum izinleri gereklidir\n'
              '• İnternet bağlantısı harita görüntüleme için gereklidir',
            ),
            const SizedBox(height: 16),
            const Text(
              'Özellikler:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('Canlı hız takibi'),
            _buildFeatureItem('EDS koridorlarında otomatik uyarı'),
            _buildFeatureItem('Koridor giriş/çıkış bildirimleri'),
            _buildFeatureItem('Geçmiş kayıtları görüntüleme'),
            _buildFeatureItem('Hız limiti aşım uyarıları'),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Hız Asistanı V1.0\n ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
} 