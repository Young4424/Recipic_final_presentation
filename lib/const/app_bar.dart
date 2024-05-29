/*const 파일에는 여러 화면에서 계속쓰는 함수 정의 */
/*app bar 관리*/
import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Pretendard',
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.black),
  );
}
