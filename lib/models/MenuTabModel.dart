import 'package:flutter/material.dart';

class MenuTabModel {
  String imagePath;
  String selctedImagePath;
  String menuName;
  bool isSelected;
  int index;
  AnimationController animationController;

  MenuTabModel({
    this.imagePath = '',
    this.index = 0,
    this.selctedImagePath = "",
    this.menuName,
    this.isSelected = false,
    this.animationController,
  });

  static List<MenuTabModel> tabIconsList = [
    MenuTabModel(
      imagePath: 'assets/fitness_app/tab_home.png',
      selctedImagePath: 'assets/fitness_app/tab_home.png',
      menuName: 'Home',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    MenuTabModel(
      imagePath: 'assets/fitness_app/search_tab.png',
      selctedImagePath: 'assets/fitness_app/search_tab.png',
      menuName: 'Search',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    MenuTabModel(
      imagePath: 'assets/fitness_app/history_tab.png',
      selctedImagePath: 'assets/fitness_app/history_tab.png',
      menuName: 'History',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    MenuTabModel(
      imagePath: 'assets/fitness_app/tab_4.png',
      selctedImagePath: 'assets/fitness_app/tab_4s.png',
      menuName: "Account",
      index: 2,
      isSelected: false,
      animationController: null,
    ),
  ];
}
