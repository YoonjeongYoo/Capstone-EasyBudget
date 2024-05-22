import 'package:easybudget/database/dbConnector.dart';
import 'package:mysql_client/mysql_client.dart';

// 권한 변경
Future<void> updateAuthority(int authority, String uid, String sid) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // DB에서 유저 권한 수정
  try {
    await conn.execute(
        "UPDATE joined SET authority = :authority WHERE uid = :uid and sid = :sid",
        {"authority": authority, "uid": uid, "sid": sid});
    print('successfully updated!');
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

// 권한확인
Future<int?> authorityCheck(String uid, String sid) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // 권한 확인
  try {
    // authority 값을 직접 리턴
    result = await conn.execute(
        "SELECT authority FROM joined WHERE uid = :uid AND sid = :sid",
        {"uid": uid, "sid": sid});
    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        if (result.current as int != 1) {
          print('restricted feature!');
          return 2;
        }
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