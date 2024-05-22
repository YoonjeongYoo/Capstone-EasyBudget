import 'dart:math';
import 'package:easybudget/database/dbConnector.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:easybudget/database/space_auth_db.dart';

const int max = 1000;

Future<void> insertNotice(String title, String content, String author, String nspace) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  int? authcheck = authorityCheck(author, nspace) as int;
  if (authcheck == 2) {
    await conn.close();
  }

  int rnumber = Random().nextInt(max); // 무작위 숫자 (0-1000) 생성
  int? dupId = await confirmNoteidCheck(rnumber); // 중복된 Id 생성 체크
  while(dupId == 1) { // 중복된 Id 생성 시 무작위 숫자 재생성
    rnumber = Random().nextInt(max);
    if(dupId == -1) {
      print("error occurred!");
      break;
    }
  }

  try {
    await conn.execute(
        "INSERT INTO notification (noteid, ntitle, ndate, content, author, nspace)"
            "VALUES (:noteid, :ntitle, :ndate, :content, :author, :nspace)",
        {"noteid": rnumber, "ntitle": title, "ndate": DateTime.now(),
          "content": content, "author": author, "nspace": nspace});
    print(rnumber);
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

// 공지 확인
Future<String?> inquiry(String nspace) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // DB에서 스페이스 아이디를 이용해 notice 테이블에 공지글이 있는지 확인
  try {
    result = await conn.execute(
        "SELECT ntitle, ndate, author FROM notice WHERE nspace = :nspace",
        {"nspcae": nspace});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        // 공지글 정보가 존재하면 공지글의 index 값 반환
        return row.colAt(0);
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}

// 공지ID 중복확인
Future<int?> confirmNoteidCheck(int noteid) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // ID 중복 확인
  try {
    // 아이디가 중복이면 1 값 반환, 중복이 아니면 0 값 반환
    result = await conn.execute(
        "SELECT IFNULL((SELECT noteid FROM notice WHERE noteid=:noteid), 0)",
        {"noteid": noteid});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        return 1;
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  // 예외처리용 에러코드 -1 반환
  return -1;
}