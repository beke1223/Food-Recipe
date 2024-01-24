import 'package:flutter/material.dart';

class Item{
String headerText;
Widget expandedBody;
bool isExpanded;
  Item({required this.headerText, required this.expandedBody,this.isExpanded=false});
}