import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/address_layout.dart';
import 'package:easybudget/layout/amount_layout.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/category_layout.dart';
import 'package:easybudget/layout/cost_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/layout/itmes_layout.dart';
import 'package:easybudget/layout/pdate_layout.dart';
import 'package:easybudget/layout/pname_layout.dart';
import 'package:easybudget/layout/purchased_layout.dart';
import 'package:easybudget/layout/receipt_layout.dart';
import 'package:easybudget/layout/totalcost_layout.dart';
import 'package:easybudget/layout/writer_layout.dart';
import 'package:easybudget/screen/receipt_scan_confirm_screen.dart';
import 'package:flutter/material.dart';

class ReceiptEditScreen extends StatelessWidget {
  final String purchased;
  final String address;
  final String date;
  final List<Map<String, String>> items;
  final String totalCost;

  const ReceiptEditScreen({
    super.key,
    required this.purchased,
    required this.address,
    required this.date,
    required this.items,
    required this.totalCost
  });

  @override
  Widget build(BuildContext context) {
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
              /*Flexible(
                fit: FlexFit.tight,
                child: _VerificationBox(),
              ),*/
              ReceiptLayout(
                purchased: PurchasedEdit(existingData: purchased),
                address: AddressEdit(existingData: address,),
                pdate: PdateEdit(existingData : date),
                category: CategoryEdit(),
                writer: WriterView(name: '유윤정', uid: 'yyj0310',),
                items: ItemsEdit(existingData: items,),
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
                          builder: (context) => ReceiptScanComfirmScreen(
                            purchased: purchased,
                            address: address,
                            date: date,
                            items: items,
                            totalCost: totalCost,
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
                          fontFamily: 'NotoSansKR'
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                      ),
                      padding: EdgeInsets.all(15), // 높이를 5씩 늘림
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
