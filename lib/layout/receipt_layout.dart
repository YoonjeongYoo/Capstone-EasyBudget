import 'package:easybudget/constant/color.dart';
import 'package:flutter/material.dart';

class ReceiptLayout extends StatelessWidget {
  final Widget purchased;
  final Widget address;
  final Widget pdate;
  final Widget category;
  final Widget items;
  final Widget totalcost;
  final Widget writer;

  const ReceiptLayout({
    super.key,
    required this.purchased,
    required this.address,
    required this.pdate,
    required this.category,
    required this.items,
    required this.totalcost,
    required this.writer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 20
        ),
        decoration: BoxDecoration(
          color: Colors.white, // 내부 색상을 primaryColor로 설정
          borderRadius: BorderRadius.circular(10), // 테두리를 둥글게
          border: Border.all(
            color: Color(0xffe9ecef), // 테두리 색상 설정
            width: 1, // 테두리 두께 설정
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // 그림자 색상
              blurRadius: 5, // 그림자 흐림 반경
              offset: Offset(0, 5), // 그림자 오프셋
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                   '구매처',
                   style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.w700,
                     fontFamily: 'NotoSansKR',
                   ),
                  ),
                  purchased,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '주소',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  address,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '거래 일시',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  pdate,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '카테고리',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  category,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '작성자',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  writer,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '상품명',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  Text(
                    '수량',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  Text(
                    '금액',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xffe9ecef),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: items
            ),
            Divider(
              color: Color(0xffe9ecef),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '총 금액',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  totalcost,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}