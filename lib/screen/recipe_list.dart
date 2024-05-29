import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:realtime_object_detection/const/app_bar.dart';
import 'package:realtime_object_detection/const/recipic_color.dart';

class RecipeListScreen extends StatelessWidget {
  final List<String> ingredients;
  final List<Map<String, dynamic>> recipes;

  RecipeListScreen({required this.ingredients, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('${recipes.length}개의 레시피가 검색되었습니다'),
      body: Column(
        children: [
          _filter(onPressed: () {
            // 필터 동작 구현 필요
          }),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.75, // 조정된 부분
              children: List.generate(
                recipes.length,
                    (int index) {
                  var recipe = recipes[index];
                  int matchCount = recipe['ingredients']
                      .where((ingredient) => ingredients.contains(ingredient))
                      .length;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () => launch(recipe['link']),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: FractionallySizedBox(
                                widthFactor: 1.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: AspectRatio(
                                    aspectRatio: 1.0, // 조정된 부분
                                    child: Image.network(recipe['image'], fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['title'],
                                  style: TextStyle(
                                    fontFamily: 'Nanum_Barun',
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.timer, size: 12, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      '${recipe['time']}분',
                                      style: TextStyle(
                                        fontFamily: 'Nanum_Barun',
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '일치하는 재료: $matchCount개',
                                  style: TextStyle(
                                    fontFamily: 'Nanum_Barun',
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filter({required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '필터',
            style: TextStyle(
              fontFamily: 'Pretendard',
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
