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
  const ReceiptInputScreen({super.key});

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
              /*Flexible(
                fit: FlexFit.tight,
                child: _VerificationBox(),
              ),*/
              ReceiptLayout(
                //purchased: PurchasedView(perchased: '(수원) 222경기대학교 구내 서점',),
                purchased: PurchasedEdit(existingData: null),
                //address: AddressView(address: '경기 수원시 영통구 광교산로 154-42',),
                address: AddressEdit(existingData: null,),
                //pdate: PdateView(pdate: '2024-03-13',),
                pdate: PdateEdit(existingData : null),
                //category: CategoryView(category: '식비',),
                category: CategoryEdit(),
                //writer: WriterView(name: '유윤정', uid: 'yyj0310',),
                writer: WriterView(name: '유윤정', uid: 'yyj0310',),
                //pname: PnameView(pname: '운영체제 10판',),
                items: ItemsEdit(existingData : [Map()]),
                /*pname: PnameEdit(existingData: null,),
                //amount: AmountView(amount: '1',),
                amount: AmountEdit(existingData: null,),
                //cost: CostView(cost: '39,000',),
                cost: CostEdit(existingData: null,),*/
                //totalcost: TotalCostView(totalcost: '39,000',),
                totalcost: TotalCostView(totalcost: null ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {

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
}