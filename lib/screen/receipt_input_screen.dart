import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/layout/address_layout.dart';
import 'package:easybudget/layout/category_layout.dart';
import 'package:easybudget/layout/itmes_layout.dart';
import 'package:easybudget/layout/pdate_layout.dart';
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
                  //DB에 값을 저장하는 코드
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
      String purchased,
      String address,
      String date,
      String category,
      String writer,
      List<Map<String, String>> items,
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
