import 'package:easybudget/database/hashPassword.dart';
import 'package:easybudget/database/dbConnector.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 계정 생성
Future<void> insertMember(String uid, String pw, String uname) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 비밀번호 암호화
  //final hash = hashPassword(pw);

  // DB에 유저 정보 추가
  try {
    await conn.execute(
        "INSERT INTO users (uid, pw, uname) VALUES (:uid, :pw, :uname)",
        {"uid": uid, "pw": pw, "unmae": uname});
    print(pw);
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

// 로그인
Future<String?> login(String uid, String pw) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 비밀번호 암호화
  //final hash = hashPassword(pw);

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // DB에 해당 유저의 아이디와 비밀번호를 확인하여 users 테이블에 있는지 확인
  try {
    result = await conn.execute(
        "SELECT uid FROM users WHERE uid = :uid and pw = :pw",
        {"uid": uid, "pw": pw});

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
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}

// 로그인한 유저ID 인스턴스에 저장
Future<void> saveUserID(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

// 인스턴스에 저장된 유저ID 찾기
Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString('uid') != null) {
    return prefs.getString('uid').toString();
  } else {
    return '-1';
  }
}

// 인스턴스에 저장된 ID 삭제
Future<void> removeUserId() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('uid');
}

// 유저ID 중복확인
Future<String?> confirmIdCheck(String uid) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // ID 중복 확인
  try {
    // 아이디가 중복이면 1 값 반환, 중복이 아니면 0 값 반환
    result = await conn.execute(
        "SELECT IFNULL((SELECT uid FROM users WHERE uid=:uid), 0)",
        {"uid": uid});

    if (result.isNotEmpty) {
      for (final row in result.rows) {
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