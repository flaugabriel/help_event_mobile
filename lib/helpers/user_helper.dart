import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


final String UserTable = "userTable";

final String idColumn = "idColumn";
final String emailColumn = "email";
final String uidColumn = "uid";
final String nameColum = "name";
final String contenttypeColum = "content_type";
final String accesstokenColum = "access_token";
final String clientColum = "client";


class UserHelper {
  static final UserHelper _instance = UserHelper.internal();

  factory UserHelper() => _instance;

  UserHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "Usersnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db
              .execute("CREATE TABLE $UserTable($idColumn INTEGER PRIMARY KEY, "
              "$uidColumn TEXT, $emailColumn, TEXT"
              ", $nameColum TEXT,$accesstokenColum TEXT, $clientColum TEXT, $contenttypeColum TEXT )");
        });
  }

  Future<User> saveUser(User user) async {
    Database dbUser = await db;
    user.id = await dbUser.insert(UserTable, user.toMap());
    return user;
  }

  Future<User> getUser() async {
    Database dbUser = await db;
    List<Map> maps = await dbUser.query(UserTable,
        columns: [idColumn, nameColum, emailColumn, uidColumn, accesstokenColum, clientColum, contenttypeColum],
        where: "$idColumn = 1 ",
        whereArgs: [1]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
  }

  Future<int> deleteUser(int id) async {
    Database dbUser = await db;
    return await dbUser
        .delete(UserTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  updateUser(User user) async {
    Database dbUser = await db;
    return await dbUser.update(UserTable, user.toMap(),
        where: "$idColumn = ?", whereArgs: [user.id]);
  }

  Future<List> getAllUsers() async {
    Database dbUser = await db;
    var rawQuery = dbUser.rawQuery("SELECT * FROM $UserTable");
    List listMap = await rawQuery;
    List<User> listUser = List();
    for (Map m in listMap) {
      listUser.add(User.fromMap(m));
    }
    return listUser;
  }

  Future<int> getNumber() async {
    Database dbUser = await db;
    return Sqflite.firstIntValue(
        await dbUser.rawQuery("SELECT COUNT(*) FROM $dbUser"));
  }

  Future close() async {
    Database dbUser = await db;
    await dbUser.close();
  }
}

class User {

  int id;
  String name;
  String email;
  String uid;
  String acces;
  String content_type;
  String access_token;
  String client;


  User.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColum];
    email = map[emailColumn];
    uid = map[uidColumn];
    client = map[clientColum];
    access_token = map[accesstokenColum];
    content_type = map[contenttypeColum];
  }

  User();

  Map toMap() {
    Map<String, dynamic> map = {
      name: name,
      emailColumn: email,
      uidColumn: uid,
      clientColum: client,
      accesstokenColum: access_token,
      contenttypeColum: content_type
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "User(id: $id, name: $name, email: $email, uid: $uid, client: $client, access_token: $access_token, content_type: $content_type)";
  }
}
