import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/address_layout.dart';
//import 'package:easybudget/layout/amount_layout.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/category_layout.dart';
//import 'package:easybudget/layout/cost_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/layout/itmes_layout.dart';
import 'package:easybudget/layout/pdate_layout.dart';
//import 'package:easybudget/layout/pname_layout.dart';
import 'package:easybudget/layout/purchased_layout.dart';
import 'package:easybudget/layout/receipt_layout.dart';
import 'package:easybudget/layout/totalcost_layout.dart';
import 'package:easybudget/layout/writer_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Timestamp 클래스를 사용하기 위해 추가

class ExpenseDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> expense;

  const ExpenseDetailsScreen({Key? key, required this.expense}) : super(key: key);

  Future<List<Map<String, String>>> _fetchItems() async {
    // Firestore에서 items를 가져옵니다.
    final itemsSnapshot = await FirebaseFirestore.instance
        .collection('Space')
        .doc('u3dYxuN5bv8BxjV6AzpF')
        .collection('Receipts')
        .doc(expense['id']) // 각 영수증의 고유 ID가 있다고 가정
        .collection('Item')
        .get();

    // 데이터를 Map의 List로 변환하고, 모든 값들을 문자열로 변환합니다.
    List<Map<String, String>> itemsList = itemsSnapshot.docs.map((doc) {
      final data = doc.data();
      return data.map((key, value) => MapEntry(key, value.toString())); // 모든 값을 문자열로 변환
    }).toList();

    return itemsList;
  }

  @override
  Widget build(BuildContext context) {

    // Timestamp를 DateTime으로 변환
    DateTime pdate = (expense['pdate'] as Timestamp).toDate();
    // 원하는 형식으로 DateTime을 문자열로 변환
    String formattedPdate = '${pdate.year}-${pdate.month.toString().padLeft(2, '0')}-${pdate.day.toString().padLeft(2, '0')}';


    return DefaultLayout(
      appbar: AppbarLayout(
        title: '상세 영수증 내역 확인',
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
                purchased: PurchasedView(perchased: '${expense['store']}',),
                //purchased: PurchasedEdit(existingData: '(수원) 경기대학교 구내 서점'),
                address: AddressView(address: '${expense['address']}',),
                //address: AddressEdit(existingData: '경기 수원시 영통구 광교산로 154-42',),
                pdate: PdateView(pdate: formattedPdate,),
                //pdate: PdateEdit(existingData : '2024-03-13'),
                category: CategoryView(category: '${expense['category']}',),
                //category: CategoryEdit(),
                writer: WriterView(name: '${expense['pname']}', uid: 'yyj0310',),
                //writer: WriterView(name: '유윤정', uid: 'yyj0310',),
                /*pname: PnameView(pname: '${expense['item']}',),
                //pname: PnameEdit(existingData: '운영체제 10판',),
                amount: AmountView(amount: '1',),
                //amount: AmountEdit(existingData: '1',),
                cost: CostView(cost: '${expense['amount']}',),*/
                //items: ItemsView(items: [Map()],),
                // Firebase에서 가져온 items를 표시하기 위해 FutureBuilder 사용
                items: FutureBuilder<List<Map<String, String>>>(
                  future: _fetchItems(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No items found.');
                    } else {
                      return ItemsView(items: snapshot.data!);
                    }
                  },
                ),
                //cost: CostEdit(existingData: '39,000',),
                totalcost: TotalCostView(totalcost: '${expense['amount']}',),
                //totalcost: TotalCostView(totalcost: null ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
            ],
          ),
        ),
      ),
    );
  }
}