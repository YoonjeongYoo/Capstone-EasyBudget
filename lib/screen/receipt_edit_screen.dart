import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/address_layout.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/category_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/layout/itmes_layout.dart';
import 'package:easybudget/layout/pdate_layout.dart';
import 'package:easybudget/layout/purchased_layout.dart';
import 'package:easybudget/layout/receipt_layout.dart';
import 'package:easybudget/layout/totalcost_layout.dart';
import 'package:easybudget/layout/writer_layout.dart';
import 'package:easybudget/screen/receipt_scan_confirm_screen.dart';
import 'package:flutter/material.dart';

class ReceiptEditScreen extends StatelessWidget {
  final String userId;
  final String purchased;
  final String address;
  final String date;
  final String category;
  final List<Map<String, String>> items;
  final String totalCost;

  const ReceiptEditScreen({
    super.key,
    required this.userId,
    required this.purchased,
    required this.address,
    required this.date,
    required this.category,
    required this.items,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController purchasedController = TextEditingController(text: purchased);
    final TextEditingController addressController = TextEditingController(text: address);
    final TextEditingController dateController = TextEditingController(text: date);
    final TextEditingController categoryController = TextEditingController(text: category);
    final TextEditingController totalCostController = TextEditingController(text: totalCost);

    final GlobalKey<ItemsEditState> itemsEditKey = GlobalKey<ItemsEditState>();

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
                purchased: PurchasedEdit(controller: purchasedController),
                address: AddressEdit(controller: addressController),
                pdate: PdateEdit(controller: dateController),
                category: CategoryEdit(controller: categoryController),
                writer: WriterView(name: '유윤정', uid: 'yyj0310'),
                items: ItemsEdit(key: itemsEditKey, existingData: items),
                totalcost: TotalCostEdit(controller: totalCostController),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final itemsData = itemsEditKey.currentState!.controllers.map((item) {
                        return {
                          'name': item['name']!.text,
                          'count': item['count']!.text,
                          'cost': item['cost']!.text,
                        };
                      }).toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptScanComfirmScreen(
                            userId: userId,
                            purchased: purchasedController.text,
                            address: addressController.text,
                            date: dateController.text,
                            category: categoryController.text,
                            items: itemsData,
                            totalCost: totalCostController.text,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      foregroundColor: primaryColor,
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'NotoSansKR'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(15),
                    ),
                    child: Text(
                      '저장',
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
}
