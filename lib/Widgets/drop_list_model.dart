import 'package:flutter/material.dart';

class DropListModel {
  DropListModel(this.listOptionItems);

  final List<OptionItem> listOptionItems;
}

class OptionItem {
  final int roomTypeId;
  final String roomTypeName;

  OptionItem({required this.roomTypeId, required this.roomTypeName});
}