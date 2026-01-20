// Conditional export: memilih implementasi database yang tepat sesuai platform
// Untuk platform mobile (Android/iOS) menggunakan db_service_mobile.dart (sqflite)
// Untuk platform web menggunakan db_service_stub.dart (SharedPreferences via WebStorageService)
export 'db_service_stub.dart'
    if (dart.library.io) 'db_service_mobile.dart';

