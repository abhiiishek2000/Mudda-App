import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/MuddaPostOfflineModel.dart';
import '../../model/RecentDataModel.dart';
import '../../model/SupportChatOfflineModel.dart';
import '../../ui/screens/other_user_profile/model/chat_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "muddaapp.db");
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        //org chat table
        await db.execute("CREATE TABLE ORGCHATS ("
            "id INTEGER PRIMARY KEY,"
            "userId TEXT,"
            "fullName TEXT,"
            "userName TEXT,"
            "userProfile TEXT,"
            "activity TEXT,"
            "isGroup BOOLEAN,"
            "isSend BOOLEAN,"
            "category TEXT,"
            "chatId TEXT,"
            "lastChatId TEXT UNIQUE,"
            "type TEXT,"
            "message TEXT,"
            "createdAt TEXT,"
            "_id TEXT"
            ")");
        // await db.execute("CREATE TABLE SAVEPOSTID ("
        //     "id INTEGER PRIMARY KEY,"
        //     "mudda_id TEXT,"
        //     "_id TEXT"
        //     ")");

        // await db.execute("alter table SHAGUNS add column gift TEXT");
      }
    }, onCreate: (Database db, int version) async {
      // Chats Table
      await db.execute("CREATE TABLE CHATS ("
          "id INTEGER PRIMARY KEY,"
          "userId TEXT,"
          "isGroup BOOLEAN,"
          "isSend BOOLEAN,"
          "category TEXT,"
          "chatId TEXT,"
          "lastChatId TEXT UNIQUE,"
          "type TEXT,"
          "message TEXT,"
          "createdAt TEXT,"
          "_id TEXT"
          ")");

      // Post Table
      await db.execute("CREATE TABLE MUDDAFORPOST ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "_id TEXT UNIQUE,"
          "user_id TEXT,"
          "mudda_id TEXT,"
          "post_as TEXT,"
          "thumbnail TEXT,"
          "title TEXT,"
          "mudda_description TEXT,"
          "post_in TEXT,"
          "createdAt TEXT,"
          "file TEXT,"
          "path TEXT,"
          "commentorsCount INTEGER,"
          "likersCount INTEGER,"
          "dislikersCount INTEGER,"
          "agreeStatus BOOLEAN,"
          "fullname TEXT,"
          "profile TEXT,"
          "parentPost TEXT [],"
          "replies INTEGER"
          ")");

      await db.execute("CREATE TABLE ADMINCHATS ("
          "id INTEGER PRIMARY KEY,"
          "userId TEXT,"
          "isSend BOOLEAN,"
          "chatId TEXT,"
          "lastChatId TEXT UNIQUE,"
          "type TEXT,"
          "message TEXT,"
          "createdAt TEXT,"
          "_id TEXT"
          ")");

      await db.execute("CREATE TABLE RECENTUPDATE ("
          "id INTEGER PRIMARY KEY,"
          "muddaId TEXT UNIQUE,"
          "leadersCount TEXT,"
          "totalPost TEXT,"
          "support TEXT,"
          "inDebate TEXT"
          ")");
      //org chat table
      await db.execute("CREATE TABLE ORGCHATS ("
          "id INTEGER PRIMARY KEY,"
          "userId TEXT,"
          "fullName TEXT,"
          "userName TEXT,"
          "userProfile TEXT,"
          "activity TEXT,"
          "isGroup BOOLEAN,"
          "isSend BOOLEAN,"
          "category TEXT,"
          "chatId TEXT,"
          "lastChatId TEXT UNIQUE,"
          "type TEXT,"
          "message TEXT,"
          "createdAt TEXT,"
          "_id TEXT"
          ")");
    });
  }

  // add messages
  addMessages({
    required String userId,
    required bool isGroup,
    required bool isSend,
    required String category,
    required String chatId,
    required String lastChatId,
    required String type,
    required String message,
    required String createdAt,
    required String ids,
  }) async {
    final db = await database;
    try {
      var raw = await db?.rawInsert(
          "INSERT Into CHATS (userId,isGroup,isSend,category,chatId,lastChatId,type,message,createdAt,_id)"
          " VALUES (?,?,?,?,?,?,?,?,?,?)",
          [
            userId,
            isGroup,
            isSend,
            category,
            chatId,
            lastChatId,
            type,
            message,
            createdAt,
            ids
          ]);
      return raw;
    } catch (e) {
      print(e);
    }
  }

// get messages by id
  Future<List<Chat>> getChats(String ids) async {
    final db = await database;
    var res = await db?.rawQuery(
        "SELECT * from CHATS where _id = '$ids' ORDER by createdAt DESC");
    List<Chat> list =
        res!.isNotEmpty ? res.map((c) => Chat.fromMap(c)).toList() : [];
    print(list.length);
    return list;
  }

  //delete messages by id
  deleteIndivitualChatById(String id) async {
    final db = await database;
    var raw = await db?.delete('CHATS', where: 'chatId = ?', whereArgs: [id]);
    return raw;
  }

 Future<void> deleteIndivitualOrgChatById(String id) async {
    final db = await database;
    await db?.delete('ORGCHATS', where: 'chatId = ?', whereArgs: [id]);
  }

  // Add MuddaPost
  addMuddaPostData(
      {String? id,
      String? user_id,
      String? mudda_id,
      String? post_as,
      String? thumbnail,
      String? title,
      String? mudda_description,
      String? post_in,
      String? createdAt,
      String? file,
      String? path,
      int? commentorsCount,
      int? likersCount,
      int? dislikersCount,
      bool? agreeStatus,
      String? fullname,
      String? profile,
      int? replies,
      List<String>? parentPost}) async {
    final db = await database;
    try {
      var raw = await db?.rawInsert(
          "INSERT Into MUDDAFORPOST (_id,user_id,mudda_id,post_as,thumbnail,title,mudda_description,post_in,createdAt,file,path,commentorsCount,likersCount,dislikersCount,agreeStatus,fullname,profile,replies,parentPost)"
          " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            id,
            user_id,
            mudda_id,
            post_as,
            thumbnail,
            title,
            mudda_description,
            post_in,
            createdAt,
            file,
            path,
            commentorsCount,
            likersCount,
            dislikersCount,
            agreeStatus,
            fullname,
            profile,
            replies,
            parentPost
          ]);
      return raw;
    } catch (e) {
      print(e);
    }
  }

// Get MuddaPost By muddaId
  Future<List<MuddaOfflinePost>> getPosts(String muddaId) async {
    final db = await database;
    var res = await db
        ?.rawQuery("SELECT * from MUDDAFORPOST where mudda_id = '$muddaId'");
    List<MuddaOfflinePost> list = res!.isNotEmpty
        ? res.map((c) => MuddaOfflinePost.fromMap(c)).toList()
        : [];
    print(list.length);
    return list;
  }

  // Delete post
  deletePost(String id) async {
    final db = await database;
    try {
      print("delete start------>");
      var raw = await db
          ?.rawDelete('DELETE FROM MUDDAFORPOST WHERE mudda_id = ?', [id]);
      return raw;
    } catch (e) {
      print("delete failed------$e");
    }
  }

// add admin messages
  addAdminMessages({
    required String userId,
    required bool isSend,
    required String chatId,
    required String type,
    required String message,
    required String lastChatId,
    required String createdAt,
    required String ids,
  }) async {
    final db = await database;
    try {
      var raw = await db?.rawInsert(
          "INSERT Into ADMINCHATS (userId,isSend,chatId,type,message,lastChatId,createdAt,_id)"
          " VALUES (?,?,?,?,?,?,?,?)",
          [userId, isSend, chatId, type, message, lastChatId, createdAt, ids]);
      return raw;
    } catch (e) {
      log('$e');
    }
  }

  // get admin messages by id
  Future<List<SupportOfflineChat>> getAdminChats(String chatId) async {
    final db = await database;
    var res = await db?.rawQuery(
        "SELECT * from ADMINCHATS where chatId = '$chatId' ORDER by createdAt DESC");
    List<SupportOfflineChat> list = res!.isNotEmpty
        ? res.map((c) => SupportOfflineChat.fromMap(c)).toList()
        : [];
    print(list.length);
    return list;
  }

  addRecentData(
      {required String muddaId,
      required String leadersCount,
      required String totalPost,
      required String support,
      required String inDebate}) async {
    final db = await database;
    try {
      var raw = await db?.rawInsert(
          "INSERT Into  RECENTUPDATE(muddaId,leadersCount,totalPost,support,inDebate)"
          " VALUES (?,?,?,?,?)",
          [muddaId, leadersCount, totalPost, support, inDebate]);
      return raw;
    } catch (e) {
      log('$e');
    }
  }

  Future<List<RecentDataOffline>> getRecentData(String muddaId) async {
    final db = await database;
    var res = await db
        ?.rawQuery("SELECT * from RECENTUPDATE where muddaId = '$muddaId' ");
    List<RecentDataOffline> list = res!.isNotEmpty
        ? res.map((c) => RecentDataOffline.fromMap(c)).toList()
        : [];
    log("${list.length}");
    return list;
  }

  deleteRecentData(String muddaId) async {
    final db = await database;
    var raw = await db
        ?.delete('RECENTUPDATE', where: "muddaId", whereArgs: [muddaId]);
    return raw;
  }

  addMuddaPostId({
    required String muddaId,
    required String id,
  }) async {
    final db = await database;
    try {
      var raw = await db?.rawInsert(
          "INSERT Into  SAVEPOSTID(muddaId,_id)"
          " VALUES (?,?)",
          [muddaId, id]);
      return raw;
    } catch (e) {
      log('$e');
    }
  }


    addOrgMessages({
      required String userId,
      String? fullname,
      String? userName,
      String? userProfile,
      String? activity,
      required bool isGroup,
      required bool isSend,
      required String category,
      required String chatId,
      required String lastChatId,
      required String type,
      String? message,
      required String createdAt,
      required String ids,
    }) async {
      final db = await database;
      try {
        var raw = await db?.rawInsert(
            "INSERT Into ORGCHATS (userId,fullName,userName,userProfile,activity,isGroup,isSend,category,chatId,lastChatId,type,message,createdAt,_id)"
                " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
            [
              userId,
              fullname,
              userName,
              userProfile,
              activity,
              isGroup,
              isSend,
              category,
              chatId,
              lastChatId,
              type,
              message,
              createdAt,
              ids
            ]);
        return raw;
      } catch (e) {
        print(e);
      }
    }
// get org messages by id
  Future<List<OrgChat>> getOrgChats(String ids) async {
    final db = await database;
    var res = await db?.rawQuery(
        "SELECT * from ORGCHATS where _id = '$ids' ORDER by createdAt DESC");
    List<OrgChat> list =
    res!.isNotEmpty ? res.map((c) => OrgChat.fromMap(c)).toList() : [];
    return list;
  }
  Future<String?> getLastChats(String ids) async {
    final db = await database;
    try{
      var res = await db?.rawQuery(
          "SELECT * from CHATS where chatId = '$ids' ORDER by createdAt DESC");
      String id = res!.first['lastChatId'] as String;
      return id;
    }catch (e){
      return null;
    }
  }
  Future<String?> getOrgLastChats(String ids) async {
    final db = await database;
    try{
      var res = await db?.rawQuery(
          "SELECT * from ORGCHATS where chatId = '$ids' ORDER by createdAt DESC");
      String id = res!.first['lastChatId'] as String;
      return id;
    }catch (e){
      print(e);
      return null;
    }
  }
}
