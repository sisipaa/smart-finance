// Class ScheduleModel merepresentasikan data jadwal/kegiatan yang dijadwalkan
class ScheduleModel {
  // ID jadwal (nullable, auto-generated oleh database)
  int? id;
  // Judul atau nama kegiatan
  String title;
  // Catatan atau deskripsi detail kegiatan
  String note;
  // Tanggal dan waktu kegiatan dijadwalkan
  DateTime datetime;

  // Constructor untuk membuat instance ScheduleModel
  // id bersifat optional (nullable) karena akan di-generate oleh database
  // Parameter lain wajib diberikan (required)
  ScheduleModel({
    this.id,
    required this.title,
    required this.note,
    required this.datetime,
  });

  // Method toMap mengkonversi object ScheduleModel menjadi Map
  // Map ini digunakan untuk menyimpan data ke database
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'note': note,
        // Konversi DateTime ke ISO 8601 string untuk disimpan di database
        'datetime': datetime.toIso8601String(),
      };

  // Factory constructor fromMap mengkonversi Map (dari database) menjadi object ScheduleModel
  // Digunakan saat membaca data jadwal dari database
  factory ScheduleModel.fromMap(Map<String, dynamic> m) {
    return ScheduleModel(
      id: m['id'],
      title: m['title'],
      note: m['note'],
      // Parse ISO 8601 string kembali menjadi DateTime object
      datetime: DateTime.parse(m['datetime']),
    );
  }
}

