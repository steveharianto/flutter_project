import 'package:mysql1/mysql1.dart';

class DatabaseService {
  static Future<MySqlConnection> getConnection() async {
    final settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: '',
        db: 'adminduk_db');

    try {
      final conn = await MySqlConnection.connect(settings);
      return conn;
    } catch (e) {
      throw Exception('Failed to connect to database: $e');
    }
  }
}
