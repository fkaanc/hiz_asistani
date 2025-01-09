# Hız Asistanı

EDS (Elektronik Denetleme Sistemi) koridorlarında sürücülere yardımcı olmak amacıyla geliştirilmiş bir mobil uygulamadır. GPS tabanlı konum takibi ve Google Maps entegrasyonu kullanarak sürücülerin hız limitlerini aşmalarını önlemeyi amaçlar.

## Özellikler

- 🚗 Anlık hız takibi
- 🗺️ Google Maps entegrasyonu
- ⚡ EDS koridorlarında otomatik uyarı sistemi
- 📊 Geçmiş seyahat kayıtları
- 🔔 Hız limiti aşım uyarıları
- 📍 GPS tabanlı konum takibi
- 📱 Kullanıcı dostu arayüz

## EDS Koridorları
2 adet test koridoru, 1 adet gerçek koridor bulunmakta.

- NTAL EDS (10 km/h) _test_
- Hisarcık EDS (70 km/h) _test_
- Paşalı EDS (50 km/h) ***gerçek***

## Kurulum

1. Projeyi klonlayın: `git clone https://github.com/fkaanc/hiz_asistani.git`
2. Bağımlılıkları yükleyin: `flutter pub get`
3. API anahtarını ayarlayın:` dart
// lib/config/api_keys.dart
class ApiKeys {
static const String googleMapsApiKey = 'YOUR_API_KEY';
}`
4. `flutter run`

   
## Kullanılan Teknolojiler

- Flutter/Dart
- Google Maps API
- Geolocator
- Dio HTTP Client

## Gereksinimler

- Flutter SDK
- Android Studio / VS Code
- Google Maps API Key
- Android/iOS Emulator veya fiziksel cihaz
