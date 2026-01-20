// Conditional export: memilih implementasi yang tepat sesuai platform
// Untuk web menggunakan implementasi dengan mendengarkan perubahan URL hash
// Untuk mobile menggunakan stub (no-op) karena tidak relevan
export 'web_hash_listener_stub.dart' if (dart.library.html) 'web_hash_listener_web.dart';
