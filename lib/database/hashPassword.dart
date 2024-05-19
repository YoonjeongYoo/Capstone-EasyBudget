import 'package:crypto/crypto.dart';
import 'dart:convert';

String hashPassword(String pw) {
  const uniqueKey = 'idontwannado';
  final bytes = utf8.encode(pw + uniqueKey);
  final hash = sha256.convert(bytes);
  return hash.toString();
}