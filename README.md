# Hız Asistanı

EDS (Elektronik Denetleme Sistemi) koridorlarında ortalama hızından emin olamayan sürücülere yardımcı olmak amacıyla geliştirilmiş bir mobil uygulamadır. GPS tabanlı konum takibi ve Google Maps entegrasyonu kullanarak sürücülerin hız limitlerini aşmalarını önlemeyi amaçlar.

![Image](https://github.com/user-attachments/assets/d98d2c68-e344-41e4-9c63-7905995265ab)

## Özellikler

- 🚗 Anlık hız takibi
- 🗺️ Google Maps entegrasyonu
- ⚡ EDS koridorlarında otomatik uyarı sistemi
- 📊 Geçmiş seyahat kayıtları
- 🔔 Hız limiti aşım uyarıları
- 📍 GPS tabanlı konum takibi
- 📱 Kullanıcı dostu arayüz

![Image](https://github.com/user-attachments/assets/eb7c7497-6316-4a36-8a26-dbc4b4b3c777)

## EDS Koridorları
2 adet test koridoru, 1 adet gerçek koridor bulunmakta.

- NTAL EDS (10 km/h) _test_
- Paşalı EDS (50 km/h) _test_  
- Hisarcık EDS (70 km/h) ***gerçek***

![Image](https://github.com/user-attachments/assets/bca0e487-aadb-42eb-bdc4-4284acf89248)

![Image](https://github.com/user-attachments/assets/2342559a-db7d-4e79-9919-99e341c6df1f)

![Image](https://github.com/user-attachments/assets/961595ff-c029-43e6-b864-15f629d11149)

## Kurulum

1. Projeyi klonlayın: `git clone https://github.com/fkaanc/hiz_asistani.git`
2. `lib/config/api_keys.example.dart` konumunda olan dosyanın ismini `api_keys.dart` olarak değiştirin
3. `api_keys.dart` dosyasında `YOUR_API_KEY_HERE` yerine kendi API anahtarınızı ekleyin
4. `android/app/src/main/AndroidManifest.xml` dosyasında `YOUR_API_KEY_HERE` Google Maps API anahtarınızı ekleyin
5. Flutter paketlerini yükleyin: `flutter pub get`
6. Uygulamayı çalıştırın: `flutter run`

   
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






