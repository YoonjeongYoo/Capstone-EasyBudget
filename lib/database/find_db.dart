import 'package:easybudget/database/hashPassword.dart';
import 'package:easybudget/database/dbConnector.dart';
import 'package:mysql_client/mysql_client.dart';

// ID 찾기
Future<String?> findId(String uname) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  IResultSet? result;

  // DB에서 유저 정보 검색
  try {
    result = await conn.execute(
        "SELECT uid FROM users WHERE uname = :uname",
        {"uname": uname});
    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        // 유저 정보가 존재하면 유저의 index 값 반환
        return row.colAt(0);
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

// PW 찾기
Future<String?> findPW(String uid) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  IResultSet? result;

  // DB에서 유저PW 검색
  try {
    result = await conn.execute(
        "SELECT pw FROM users WHERE uid = :uid",
        {"uid": uid});
    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        // 유저 정보가 존재하면 유저의 index 값 반환
        return row.colAt(0);
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}