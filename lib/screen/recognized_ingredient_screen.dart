import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:realtime_object_detection/const/app_bar.dart';
import 'package:realtime_object_detection/const/recipic_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'recipe_list.dart';
import 'package:realtime_object_detection/data/recipes.dart';
import 'package:realtime_object_detection/screen/user_add_ingredient.dart';

class RecognizedIngredientsScreen extends StatefulWidget {
  final Set<String> recogIngr;

  RecognizedIngredientsScreen({required this.recogIngr});

  @override
  _RecognizedIngredientsScreenState createState() =>
      _RecognizedIngredientsScreenState();
}

class _RecognizedIngredientsScreenState
    extends State<RecognizedIngredientsScreen> {
  Set<String> selectedIngredients = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('${widget.recogIngr.length}개의 재료가 인식되었습니다'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10),
                          child: Text('※ 스크롤하여 재료를 확인해주세요',
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 11,
                                  color: Colors.red)),
                        ),
                        GFButton(
                          onPressed: () {
                            _deleteIngr();
                          },
                          child: Text(
                            '삭제하기',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: GFColors.DANGER,
                          shape: GFButtonShape.pills,
                          size: GFSize.SMALL,
                        ),
                      ],
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 500,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.recogIngr.length,
                        itemBuilder: (context, index) {
                          final ingredient = widget.recogIngr.elementAt(index);
                          final isSelected =
                          selectedIngredients.contains(ingredient);

                          return GFCheckboxListTile(
                            title: Text(
                              '$ingredient',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.red : Colors.black,
                              ),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            size: 15,
                            activeBgColor: Colors.red,
                            type: GFCheckboxType.circle,
                            activeIcon: Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  selectedIngredients.add(ingredient);
                                } else {
                                  selectedIngredients.remove(ingredient);
                                }
                              });
                            },
                            value: isSelected,
                            inactiveIcon: null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _button(
                onPressed: fetchRecipesAndNavigate, // 레시피 검색 함수 호출
                title: '레시피 보러 가기',
              ),
              SizedBox(height: 5),
              _button(
                onPressed: () {
                  // 현재 인식된 재료 목록을 UserAddIngredientScreen에 전달
                  Get.to(() => UserAddIngredientScreen(remainIngr: widget.recogIngr.toList()));
                },
                title: '재료 추가하기',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 재료 삭제 로직
  void _deleteIngr() {
    setState(() {
      selectedIngredients.forEach((ingredient) {
        widget.recogIngr.remove(ingredient);
      });
      selectedIngredients.clear();
    });
  }

  // 레시피 검색 함수
  void fetchRecipesAndNavigate() {
    // 선택된 재료와 일치하는 레시피 필터링 및 정렬
    List<Map<String, dynamic>> filteredRecipes = recipes
        .where((recipe) => recipe['ingredients']
        .any((ingredient) => widget.recogIngr.contains(ingredient)))
        .toList();

    // 일치하는 재료 수에 따라 정렬
    filteredRecipes.sort((a, b) {
      int aMatchCount = a['ingredients']
          .where((ingredient) => widget.recogIngr.contains(ingredient))
          .length;
      int bMatchCount = b['ingredients']
          .where((ingredient) => widget.recogIngr.contains(ingredient))
          .length;
      return bMatchCount.compareTo(aMatchCount);
    });

    // RecipeListScreen으로 이동
    Get.to(() => RecipeListScreen(
      ingredients: widget.recogIngr.toList(),
      recipes: filteredRecipes, // 필터링되고 정렬된 레시피 전달
    ));
  }


  // 버튼 위젯
  Widget _button({required VoidCallback onPressed, required String title}) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: DARKGREEN,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 12), // 버튼 높이 줄이기
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard',
            color: Colors.white,
            fontSize: 16, // 글자 크기 줄이기
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
