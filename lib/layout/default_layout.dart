import 'package:easybudget/constant/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DefaultLayout extends StatelessWidget {
  final PreferredSizeWidget appbar;
  final Widget body;

  const DefaultLayout({
    required this.appbar,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: appbar,
      body: body,
    );
  }
}