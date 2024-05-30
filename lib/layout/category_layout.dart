import 'package:flutter/material.dart';

/*final Widget category;*/

class CategoryView extends StatelessWidget {
  final String category;

  const CategoryView({super.key, required this.category,});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$category',
      style: TextStyle(

          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoSansKR',
          color: Colors.black54
      ),
    );
  }
}

class CategoryEdit extends StatefulWidget {
  final TextEditingController controller;

  const CategoryEdit({super.key, required this.controller});

  @override
  State<CategoryEdit> createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  final _categories = ['카테고리 선택', '교통비', '식비', '도서']; // DB에서 받아오도록
  String? _selectedCat;

  @override
  void initState() {
    super.initState();
    _selectedCat = widget.controller.text.isNotEmpty ? widget.controller.text : _categories[0];
    widget.controller.text = _selectedCat!;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _selectedCat,
      items: _categories
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCat = value;
          widget.controller.text = value!;
        });
      },
    );
  }
}