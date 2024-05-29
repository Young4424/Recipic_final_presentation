/*다음 페이지로 가는 함수 관리*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 이 함수는 백엔드로부터 데이터를 가져오고, 다음 화면으로 이동합니다.
Future<void> navigateToScreenWithData(BuildContext context, String apiUrl, Widget Function(dynamic data) screenBuilder) async {
  try {
    // 백엔드로부터 데이터를 가져옵니다.
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // 데이터와 함께 다음 화면으로 이동합니다.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => screenBuilder(data),
      ));
    } else {
      // 오류 처리
      print('Failed to load data');
    }
  } catch (e) {
    // 예외 처리
    print(e.toString());
  }
}