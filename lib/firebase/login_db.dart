import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 임포트 추가
import '../firebase/object_db.dart';
import 'package:flutter/material.dart';

// SharedPreferences에 유저 ID를 저장하는 함수
Future<void> saveUserID(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

// SharedPreferences에서 유저 ID를 가져오는 함수
Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}