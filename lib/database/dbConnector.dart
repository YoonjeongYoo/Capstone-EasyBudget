import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:easybudget/database/dbInfo.dart';

Future<MySQLConnection> dbConnector() async {
  print("Connecting to mysql server...");

  // MySQL 접속 설정
  final conn = await MySQLConnection.createConnection(
    host: DbInfo.hostName,
    port: DbInfo.portNumber,
    userName: DbInfo.userName,
    password: DbInfo.password,
    databaseName: DbInfo.dbName, // optional
  );

  // 연결 대기
  await conn.connect();

  print("Connected");


  return conn;
 /* // 종료 대기
  await conn.close();*/
}