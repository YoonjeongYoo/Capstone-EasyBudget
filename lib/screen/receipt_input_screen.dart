import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/address_layout.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/bottom_navigationbar_layout.dart';
import 'package:easybudget/layout/category_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/layout/itmes_layout.dart';
import 'package:easybudget/layout/pdate_layout.dart';
import 'package:easybudget/layout/purchased_layout.dart';
import 'package:easybudget/layout/receipt_layout.dart';
import 'package:easybudget/layout/totalcost_layout.dart';
import 'package:easybudget/layout/writer_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ReceiptInputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController purchasedController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController totalCostController = TextEditingController();

    final GlobalKey<ItemsEditState> itemsEditKey = GlobalKey<ItemsEditState>();

    return DefaultLayout(
      appbar: AppbarLayout(
        title: '영수증 수기 입력',
        action: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ReceiptLayout(
                purchased: PurchasedEdit(controller: purchasedController),
                address: AddressEdit(controller: addressController),
                pdate: PdateEdit(controller: dateController),
                category: CategoryEdit(controller: categoryController),
                writer: WriterView(name: '유윤정', uid: 'yyj0310'), //user 값 받아와서..
                items: ItemsEdit(key: itemsEditKey, existingData: [{}]),
                totalcost: TotalCostEdit(controller: totalCostController),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String purchased = purchasedController.text;
                  String address = addressController.text;
                  String date = dateController.text;
                  String category = categoryController.text;
                  String totalCost = totalCostController.text;

                  List<Map<String, String>> items = itemsEditKey.currentState!.getItems();

                  await addReceiptToFirebase(context, purchased, address, date, category, '유윤정', items, totalCost);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(15),
                ),
                child: Text(
                  '등록',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addReceiptToFirebase(
      BuildContext context,
      String purchased,
      String address,
      String date,
      String category,
      String writer,
      List<Map<String, String>> items,
      String totalCost,
      ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference receipts = firestore.collection('Space').doc('KBpkiTfmpsg3ZI5iSpyY').collection('Receipt');

    // 랜덤 문자열 생성
    String image = DateTime.now().millisecondsSinceEpoch.toString();

    // 아이템 변환
    List<Map<String, dynamic>> itemsData;
    try {
      itemsData = items.map((item) {
        return {
          'count': int.parse(item['count']!.replaceAll(',', '')),
          'cost': item['cost']!.replaceAll(',', ''),
          'name': item['name'],
        };
      }).toList();
    } catch (e) {
      _showErrorDialog(context, '숫자 형식 오류', '상품의 수량은 숫자만 입력해주세요.');
      return;
    }

    // 날짜 문자열 변환
    DateTime parsedDate;
    try {
      parsedDate = _parseDateString(date);
    } catch (e) {
      _showErrorDialog(context, '날짜 형식 오류', '올바른 날짜 형식으로 입력해주세요.\n 예) yyyy-MM-dd');
      return;
    }

    try {
      // 영수증 데이터 추가
      DocumentReference newReceipt = await receipts.add({
        'address': address,
        'category': category,
        'date': Timestamp.fromDate(parsedDate),
        'image': image,
        'indate': Timestamp.now(),
        'purchased': purchased,
        'totalCost': int.parse(totalCost.replaceAll(',', '')),
        'writer': writer,
      });

      print('영수증 추가 완료: ${newReceipt.id}');

      // 아이템 데이터 추가
      CollectionReference itemsCollection = newReceipt.collection('Item');
      for (var item in itemsData) {
        await itemsCollection.add(item);
        print('아이템 추가 완료: $item');
      }

      print('영수증 등록 완료');

      // 등록 완료 Dialog 표시
      _showCompletionDialog(context);

    } catch (e) {
      print('Error adding receipt: $e');
    }
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '등록 완료',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'NotoSansKR'
            ),
          ),
          content: Text(
            '영수증이 성공적으로 등록되었습니다.',
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'NotoSansKR'
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabView(spaceName: '',), // TabView 위젯으로 이동
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog 닫기
              },
            ),
          ],
        );
      },
    );
  }

  DateTime _parseDateString(String dateString) {
    // 입력된 날짜 문자열을 DateTime 형식으로 변환
    final List<DateFormat> dateFormats = [
      DateFormat('yyyy/MM/dd(EEE)', 'ko'),
      DateFormat('yyyy-MM-dd', 'ko'),
      DateFormat('yyyy/MM/dd [E]', 'ko'),
      DateFormat('yyyy/MM/dd', 'ko')
    ];

    for (var format in dateFormats) {
      try {
        return format.parse(dateString);
      } catch (e) {
        // Ignore and try the next format
      }
    }

    // Fallback: Extract year, month, day manually
    final RegExp regex = RegExp(r'^(\d{4})[/-](\d{2})[/-](\d{2})');
    final match = regex.firstMatch(dateString);
    if (match != null) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      return DateTime(year, month, day);
    }

    throw FormatException('Invalid date format: $dateString');
  }
}
