import 'package:sqflite/sqflite.dart';
import 'package:women_saftey/model/contacts_model.dart';

class DatabaseHelper {

  static Database? _db;

  static Future<Database> get database async{
if(_db==null){
return _db=await initDb();
}
return _db!;

  }


static Future<Database>initDb ()async{
String directorypath=await getDatabasesPath();
String dblocation=directorypath+'trusted_contacts.db';
return await openDatabase(dblocation,version:1,onCreate: (db,version){
  return db.execute('''
        CREATE TABLE contacts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT
        )
      ''');
} );
}

static Future<int>insertContact(Tcontacts contacts)async{
final dbclient=await database;
return await dbclient.insert('contacts', contacts.toMap());

}


static Future<List<Tcontacts>>getallcontacts()async{
  final dbclient=await database;

  final List<Map<String,dynamic>>maps=await dbclient.query('contacts');
  return maps.map((map)=>Tcontacts.fromMap(map)).toList();
}

  static Future<int> deleteContact(int id) async {
    final dbClient = await database;
    return await dbClient.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }


 static Future<int> updateContact(Tcontacts contact) async {
    final dbClient = await database;
    return await dbClient.update('contacts', contact.toMap(),
        where: 'id = ?', whereArgs: [contact.id]);
  }


  static Future<bool> isDuplicateContact(String phone) async {
  final dbClient = await database;
  final result = await dbClient.query(
    'contacts',
    where: 'phone = ?',
    whereArgs: [phone],
  );
  return result.isNotEmpty;
}
}