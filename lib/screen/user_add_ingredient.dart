import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_object_detection/const/app_bar.dart';
import 'package:realtime_object_detection/const/recipic_color.dart';
import 'package:realtime_object_detection/screen/recipe_list.dart';
import 'package:getwidget/getwidget.dart';
import 'package:realtime_object_detection/data/recipes.dart';
import 'package:realtime_object_detection/data/ingredient.dart';



class UserAddIngredientScreen extends StatefulWidget {
  final List<String> remainIngr;

  UserAddIngredientScreen({required this.remainIngr});

  @override
  _UserAddIngredientScreenState createState() => _UserAddIngredientScreenState();
}

class _UserAddIngredientScreenState extends State<UserAddIngredientScreen> {
  List<String> typedIngredients = [];
  TextEditingController _controller = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('재료 입력하기'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: [
                    ...widget.remainIngr.map((ingredient) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onLongPress: () => _showDeleteDialog(ingredient),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: YELLOW.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            ingredient,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )),
                    ...typedIngredients.map((word) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onLongPress: () => _showDeleteDialog(word),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: YELLOW.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Text(
                            word,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: '재료를 입력해볼까요? 🥕',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (value) {
                      _addIngredient(value);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addIngredient(_controller.text);
                  },
                ),
              ],
            ),
          ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          _searchButton(),
        ],
      ),
    );
  }

  // 재료 추가 로직
  void _addIngredient(String value) {
    setState(() {
      if (widget.remainIngr.contains(value)) {
        errorMessage = '이미 입력된 재료입니다';
      } else if (!initialIngredients.contains(value)) {
        errorMessage = '재료가 아닙니다';
      } else if (typedIngredients.contains(value)) {
        errorMessage = '이미 입력된 재료입니다';
      } else {
        typedIngredients.add(value);
        _controller.clear();
        errorMessage = '';
      }
    });
  }

  // 재료 검색 버튼 위젯
  Widget _searchButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          // 선택한 재료와 일치하는 레시피 필터링 및 정렬
          List<Map<String, dynamic>> filteredRecipes = recipes
              .where((recipe) => recipe['ingredients'].any(
                  (ingredient) => [...widget.remainIngr, ...typedIngredients]
                  .contains(ingredient)))
              .toList();

          filteredRecipes.sort((a, b) {
            int aMatchCount = a['ingredients']
                .where((ingredient) => [
              ...widget.remainIngr,
              ...typedIngredients
            ].contains(ingredient))
                .length;
            int bMatchCount = b['ingredients']
                .where((ingredient) => [
              ...widget.remainIngr,
              ...typedIngredients
            ].contains(ingredient))
                .length;
            return bMatchCount.compareTo(aMatchCount);
          });

          Get.to(() => RecipeListScreen(
            ingredients: [...widget.remainIngr, ...typedIngredients],
            recipes: filteredRecipes, // 필터링되고 정렬된 레시피 전달
          ));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: DARKGREEN,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        ),
        child: Text('레시피 보러 가기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }

  void _showDeleteDialog(String ingredient) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('삭제'),
          content: Text('$ingredient 재료를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.remainIngr.remove(ingredient);
                  typedIngredients.remove(ingredient);
                });
                Navigator.of(context).pop();
              },
              child: Text('삭제'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
