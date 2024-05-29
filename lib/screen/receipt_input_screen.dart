import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/layout/address_layout.dart';
import 'package:easybudget/layout/amount_layout.dart';
import 'package:easybudget/layout/category_layout.dart';
import 'package:easybudget/layout/cost_layout.dart';
import 'package:easybudget/layout/itmes_layout.dart';
import 'package:easybudget/layout/pdate_layout.dart';
import 'package:easybudget/layout/pname_layout.dart';
import 'package:easybudget/layout/purchased_layout.dart';
import 'package:easybudget/layout/receipt_layout.dart';
import 'package:easybudget/layout/totalcost_layout.dart';
import 'package:easybudget/layout/writer_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/constant/color.dart';

class ReceiptInputScreen extends StatelessWidget {
  final TextEditingController purchasedController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController writerController = TextEditingController();
  final TextEditingController itemsController = TextEditingController();
  final TextEditingController totalCostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                purchased: PurchasedEdit(existingData: null),
                address: AddressEdit(existingData: null,),
                pdate: PdateEdit(existingData : null),
                category: CategoryEdit(),
                writer: WriterView(name: '유윤정', uid: 'yyj0310',), //user 값 받아와서..
                items: ItemsEdit(existingData : [Map()]),
                //plus: ItemPlusButton(onPressed: () {  },),
                totalcost: TotalCostView(totalcost: null ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  await addReceiptToFirebase(
                    purchasedController.text,
                    addressController.text,
                    dateController.text,
                    categoryController.text,
                    writerController.text,
                    itemsController.text,
                    totalCostController.text,
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
      String purchased,
      String address,
      String date,
      String category,
      String writer,
      String items,
      String totalCost,
      ) async {
    CollectionReference receipts = FirebaseFirestore.instance.collection('receipts');
    await receipts.add({
      'purchased': purchased,
      'address': address,
      'date': date,
      'category': category,
      'writer': writer,
      'items': items,
      'totalCost': totalCost,
    });
  }
}