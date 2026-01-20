// Class TransactionModel merepresentasikan data transaksi (pemasukan/pengeluaran)
class TransactionModel {
  // ID transaksi (nullable, auto-generated oleh database)
  int? id;
  // Judul atau deskripsi transaksi
  String title;
  // Jumlah uang untuk transaksi
  double amount;
  // Tipe transaksi: 'income' (pemasukan) atau 'expense' (pengeluaran)
  String type;
  // Kategori pengeluaran (hanya diisi jika tipe = 'expense')
  String category;
  // Tanggal transaksi terjadi
  DateTime date;

  // Constructor untuk membuat instance TransactionModel
  // id bersifat optional (nullable) karena akan di-generate oleh database
  // Parameter lain wajib diberikan (required)
  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  // Method toMap mengkonversi object TransactionModel menjadi Map
  // Map ini digunakan untuk menyimpan data ke database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      // Konversi DateTime ke ISO 8601 string untuk disimpan di database
      'date': date.toIso8601String(),
    };
  }

  // Factory constructor fromMap mengkonversi Map (dari database) menjadi object TransactionModel
  // Digunakan saat membaca data dari database
  factory TransactionModel.fromMap(Map<String, dynamic> m) => TransactionModel(
    id: m['id'],
    title: m['title'],
    // Konversi nilai ke double dengan menambah 0.0 untuk ensure tipe double
    amount: m['amount'] + 0.0,
    type: m['type'],
    category: m['category'],
    // Parse ISO 8601 string kembali menjadi DateTime object
    date: DateTime.parse(m['date']),
  );
}

