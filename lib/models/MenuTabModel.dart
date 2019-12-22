import 'package:flutter/material.dart';

class MenuTabModel {
  String imagePath;
  String selctedImagePath;
  bool isSelected;
  int index;
  AnimationController animationController;

  MenuTabModel({
    this.imagePath = '',
    this.index = 0,
    this.selctedImagePath = "",
    this.isSelected = false,
    this.animationController,
  });

  static List<MenuTabModel> tabIconsList = [
    MenuTabModel(
      imagePath: 'assets/fitness_app/tab_1.png',
      selctedImagePath: 'assets/fitness_app/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    MenuTabModel(
      imagePath: 'assets/fitness_app/tab_2.png',
      selctedImagePath: 'assets/fitness_app/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,

    ),
    MenuTabModel(
      imagePath: 'assets/fitness_app/tab_3.png',
      selctedImagePath: 'assets/fitness_app/tab_3s.png',
      index: 2,
      isSelected: false,
      animationController: null,

    ),
    MenuTabModel(
      imagePath: 'assets/fitness_app/tab_4.png',
      selctedImagePath: 'assets/fitness_app/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,

    ),
  ];
}
