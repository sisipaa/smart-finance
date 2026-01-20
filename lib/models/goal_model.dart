// Class GoalModel merepresentasikan data goal/target finansial yang ingin dicapai
class GoalModel {
  // ID goal (nullable, auto-generated oleh database)
  int? id;
  // Judul atau nama goal (e.g., "Beli Laptop", "Liburan")
  String title;
  // Target jumlah uang yang ingin dicapai
  double targetAmount;
  // Jumlah uang yang sudah terkumpul saat ini
  double currentAmount;
  // Tanggal target goal (ISO string format, nullable jika tidak ada deadline)
  String? targetDate;
  // Tanggal goal dibuat (ISO string format)
  String createdAt;

  // Constructor untuk membuat instance GoalModel
  // currentAmount default 0.0 jika tidak diberikan
  // createdAt akan otomatis diisi dengan waktu saat ini jika tidak diberikan (via initializer list)
  GoalModel({
    this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.targetDate,
    String? createdAt,
    // Initializer list: jika createdAt tidak diberikan, gunakan DateTime.now() dalam format ISO 8601
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  // Method toMap mengkonversi object GoalModel menjadi Map
  // Map ini digunakan untuk menyimpan data ke database
  Map<String, dynamic> toMap() {
    return {
      // Hanya include id jika tidak null (kondisional) karena id digenerate oleh database saat insert
      if (id != null) 'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate,
      'createdAt': createdAt,
    };
  }

  // Factory constructor fromMap mengkonversi Map (dari database) menjadi object GoalModel
  // Digunakan saat membaca data goal dari database
  factory GoalModel.fromMap(Map<String, dynamic> m) => GoalModel(
        // Type checking untuk id: jika sudah int, gunakan langsung; jika num, konversi ke int
        id: m['id'] is int ? m['id'] as int : (m['id'] as num?)?.toInt(),
        // Gunakan empty string jika title null
        title: m['title'] ?? '',
        // Konversi ke double, default 0 jika null
        targetAmount: (m['targetAmount'] ?? 0).toDouble(),
        // Konversi ke double, default 0 jika null
        currentAmount: (m['currentAmount'] ?? 0).toDouble(),
        targetDate: m['targetDate'],
        // Gunakan createdAt dari map, atau ISO string dari waktu saat ini jika null
        createdAt: m['createdAt'] ?? DateTime.now().toIso8601String(),
      );
}
