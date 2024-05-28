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
        final itemName = item['name'] ?? 'Unknown';
        final itemCount = item['count'] ?? 'Unknown';
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

class ItemsEdit extends StatelessWidget {
  final List<Map<String, String>> existingData;

  const ItemsEdit({super.key, required this.existingData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: existingData.map((item) {
          final nameController = TextEditingController(text: item['name']);
          final countController = TextEditingController(text: item['count']);
          final costController = TextEditingController(text: item['cost']);

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
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}