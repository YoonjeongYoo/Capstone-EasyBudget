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

class ItemsEdit extends StatefulWidget {
  final List<Map<String, String>> existingData;

  const ItemsEdit({super.key, required this.existingData});

  @override
  State<ItemsEdit> createState() => ItemsEditState();
}

class ItemsEditState extends State<ItemsEdit> {
  List<Map<String, TextEditingController>> controllers = [];

  @override
  void initState() {
    super.initState();
    controllers = widget.existingData.map((item) {
      return {
        'name': TextEditingController(text: item['name']),
        'count': TextEditingController(text: item['count']),
        'cost': TextEditingController(text: item['cost']),
      };
    }).toList();
  }

  void addItem() {
    setState(() {
      controllers.add({
        'name': TextEditingController(),
        'count': TextEditingController(),
        'cost': TextEditingController(),
      });
    });
  }

  void removeItem(int index) {
    setState(() {
      if (controllers.length > 1) {
        controllers.removeAt(index);
      }
    });
  }

  // getItems 메서드를 추가합니다.
  List<Map<String, String>> getItems() {
    return controllers.map((controller) {
      return {
        'name': controller['name']!.text,
        'count': controller['count']!.text,
        'cost': controller['cost']!.text,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...controllers.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final nameController = item['name']!;
            final countController = item['count']!;
            final costController = item['cost']!;

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
                      minLines: 1,
                      maxLines: 1,
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
                      minLines: 1,
                      maxLines: 1,
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
                      minLines: 1,
                      maxLines: 1,
                      scrollPadding: EdgeInsets.all(5.0),
                      textInputAction: TextInputAction.done,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(CupertinoIcons.minus_circle),
                    onPressed: () => removeItem(index),
                    color: Colors.red,
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 16),
          ItemPlusButton(onPressed: addItem),
        ],
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