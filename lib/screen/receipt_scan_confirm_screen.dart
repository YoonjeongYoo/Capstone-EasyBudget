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
import 'dart:math'; // 랜덤 값을 생성하기 위해 추가

import 'receipt_edit_screen.dart';

class ReceiptScanComfirmScreen extends StatelessWidget {
  final String purchased;
  final String address;
  final String date;
  final String? category;
  final List<Map<String, String>> items;
  final String totalCost;

  const ReceiptScanComfirmScreen({
    super.key,
    required this.purchased,
    required this.address,
    required this.date,
    required this.category,
    required this.items,
    required this.totalCost
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController(text: category);

    return DefaultLayout(
      appbar: AppbarLayout(
        title: '영수증 정보 확인',
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
                purchased: PurchasedView(perchased: purchased,),
                address: AddressView(address: address,),
                pdate: PdateView(pdate: date,),
                category: CategoryEdit(controller: categoryController),
                writer: WriterView(name: '유윤정', uid: 'yyj0310',),
                items: ItemsView(items: items,),
                totalcost: TotalCostView(totalcost: totalCost,),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptEditScreen(
                            purchased: purchased,
                            address: address,
                            date: date,
                            category: categoryController.text,
                            items: items,
                            totalCost: totalCost,
                          ), // 수정
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      foregroundColor: primaryColor,
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSansKR'
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                      ),
                      padding: EdgeInsets.all(15), // 높이를 5씩 늘림
                    ),
                    child: Text(
                      '수정',
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () async {
                      await _addReceiptToFirestore(context, categoryController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      foregroundColor: primaryColor,
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSansKR'
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                      ),
                      padding: EdgeInsets.all(15), // 높이를 5씩 늘림
                    ),
                    child: Text(
                      '등록',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addReceiptToFirestore(BuildContext context, String category) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference receipts = firestore.collection('Space').doc('KBpkiTfmpsg3ZI5iSpyY').collection('Receipt');

    // 랜덤 문자열 생성
    String image = DateTime.now().millisecondsSinceEpoch.toString();

    // 아이템 변환
    List<Map<String, dynamic>> itemsData = items.map((item) {
      return {
        'amount': int.parse(item['count']!.replaceAll(',', '')),
        'cost': item['cost']!.replaceAll(',', ''),
        'item_name': item['name'],
      };
    }).toList();

    // 날짜 문자열 변환
    DateTime parsedDate = _parseDateString(date);

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
        'writer': 'yyj0310',
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
          title: Text('등록 완료'),
          content: Text('영수증이 성공적으로 등록되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabView(), // TabView 위젯으로 이동
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  DateTime _parseDateString(String dateString) {
    // 입력된 날짜 문자열을 DateTime 형식으로 변환
    final DateFormat format = DateFormat('yyyy/MM/dd(EEE)', 'ko');
    return format.parse(dateString);
  }
}
