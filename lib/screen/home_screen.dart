import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../ml_object_detection/camera_screen.dart';
import 'package:realtime_object_detection/screen/user_add_ingredient.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GFImageOverlay(
          image: AssetImage('assets/ingr_img.jpg'), // 배경 이미지 경로
          boxFit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.darken),
          child: Column(
            children: [
              _Intro(),
              Expanded(child: _Steps()),
            ],
          ),
        ),
      ),
    );
  }
}

/*1. 안녕하세요, 재료를 추가해볼까요? -> 상단부분 */
class _Intro extends StatelessWidget {
  const _Intro({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 100, bottom: 30),
      child: Image.asset(
        'assets/logo2.png', // 로고 이미지 경로
        width: 250,
      ),
    );
  }
}

/*2. 다음 단계 뭐로 갈지 고르기 -> 중/하단 부분 */
class _Steps extends StatefulWidget {
  _Steps({super.key});
  @override
  State<_Steps> createState() => _StepsState();
}

class _StepsState extends State<_Steps> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5],
          )),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 90, bottom: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text("안녕하세요 \n재료를 추가해볼까요? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    )),
              ]),
            ),
            SizedBox(
              height: 70,
            ),
            _button(
                onPressed: () {
                  // 사진 찍기 버튼 누를 때의 동작 정의
                  Get.to(() => MyHomePage(title: 'screen'));
                },
                emojiUnicode: "\u{1F4F7}",
                title: '사진 찍기',
                description: '사진을 통해 재료를 인식합니다'),
            SizedBox(
              height: 40,
            ),
            _button(
                onPressed: () {
                  // 직접 입력하기 버튼 누를 때의 동작 정의
                  Get.to(() => UserAddIngredientScreen(remainIngr: []));
                },
                emojiUnicode: "\u{2328}",
                title: '직접 입력하기',
                description: '입력한 재료로 레시피를 찾습니다'),
          ],
        ),
      ),
    );
  }

  /*버튼 부분이 꽤나 복잡해서 위젯으로 만들어 재활용*/
  Widget _button({
    required VoidCallback onPressed,
    required String emojiUnicode,
    required String title,
    required String description,
  }) {
    return Container(
      width: 320, // Set the width as needed
      height: 60, // Set the height as needed
      child: GFButton(
        shape: GFButtonShape.pills,
        onPressed: onPressed,
        color: Color(0xff2ec269).withOpacity(0.5),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 30),
              child: Text(
                emojiUnicode,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(
                  height: 5,
                ),
                Text(
                  description,
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


