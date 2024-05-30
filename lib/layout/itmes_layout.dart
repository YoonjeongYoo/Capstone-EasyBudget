import 'package:easybudget/constant/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemsView extends StatelessWidget {
  final List<Map<String, String>> items;

  const ItemsView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // 부모 스크롤에 영향을 받도록 설정
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final itemName = item['item_name'] ?? 'Unknown';
        final itemCount = item['amount'] ?? 'Unknown';
        final itemCost = item['cost'] ?? 'Unknown';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemName,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR',
                  color: Colors.black54
              ),
            ),
            Text(
              itemCount,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR',
                  color: Colors.black54
              ),
            ),
            Text(
              itemCost,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR',
                  color: Colors.black54
              ),
            ),
          ],
        );
      },
    );
  }
}

class ItemsEdit extends StatefulWidget {
  final List<Map<String, String>> existingData;

  const ItemsEdit({super.key, required this.existingData});

  @override
  State<ItemsEdit> createState() => _ItemsEditState();
}

class _ItemsEditState extends State<ItemsEdit> {
  List<Map<String, String>> newData = [];

  @override
  void initState() {
    super.initState();
    newData.addAll(widget.existingData);
  }

  void addItem() {
    setState(() {
      newData.add({'name': '', 'count': '', 'cost': ''});
    });
  }

  void removeItem(int index) {
    setState(() {
      if (newData.length > 1) {
        newData.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...newData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final nameController = TextEditingController(text: item['name']);
            final countController =
            TextEditingController(text: item['count']);
            final costController =
            TextEditingController(text: item['cost']);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: '상품명',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      scrollPhysics: BouncingScrollPhysics(),
                      keyboardType: TextInputType.text,
                      minLines: 1, // 최소 줄 수
                      maxLines: 1, // 최대 줄 수
                      scrollPadding: EdgeInsets.all(5.0),
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                  Container(
                    width: 50,
                    child: TextField(
                      controller: countController,
                      decoration: InputDecoration(
                        hintText: '수량',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      scrollPhysics: BouncingScrollPhysics(),
                      keyboardType: TextInputType.number,
                      minLines: 1, // 최소 줄 수
                      maxLines: 1, // 최대 줄 수
                      scrollPadding: EdgeInsets.all(5.0),
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                  Container(
                    width: 100,
                    child: TextField(
                      controller: costController,
                      decoration: InputDecoration(
                        hintText: '금액',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      scrollPhysics: BouncingScrollPhysics(),
                      keyboardType: TextInputType.number,
                      minLines: 1, // 최소 줄 수
                      maxLines: 1, // 최대 줄 수
                      scrollPadding: EdgeInsets.all(5.0),
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(CupertinoIcons.minus_circle),
                    onPressed: () => removeItem(index), // 삭제 버튼에 removeItem 함수 호출 추가
                    color: Colors.red,
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 16), // 추가된 버튼과 위젯 사이에 여백 추가
          ItemPlusButton(onPressed: addItem), // 추가된 버튼 위젯
        ]
      ),
    );
  }
}

class ItemPlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ItemPlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CupertinoIcons.add_circled_solid),
      onPressed: onPressed,
      color: blueColor,
    );
  }
}

