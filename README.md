# Recipic - object detection & recipe recommendation

1. 개요

프로젝트명: 재료 인식을 통한 레시피 추천 어플

목적:
2024년 홍익대학교 컴퓨터공학과 졸업 프로젝트의 주제로, 사용자가 보유하고 있는 재료를 인식하여 적절한 요리 레시피를 추천하는 어플리케이션을 개발하는 것을 목표로 하였습니다. 이를 통해, 사용자는 냉장고나 주방에 있는 재료를 효율적으로 활용하고, 쉽게 레시피를 검색할 수 있도록 하였습니다.

**주요 기능:**
- **재료 인식:** Yolo v5 모델을 이용하여 사용자가 사진으로 입력한 재료를 인식.
- **레시피 추천:** 인식된 재료를 기반으로 관련 레시피를 플러터 앱에서 추천.
- **사용자 인터페이스:** 사용하기 쉬운 플러터 기반의 모바일 어플리케이션 제공.



### 2. 제작 과정

**2.1 요구사항 분석**
- 사용자 요구사항: 사용자들이 쉽게 재료를 인식시키고, 그 재료로 만들 수 있는 다양한 레시피를 추천받을 수 있는 기능을 구현하기
- 시스템 요구사항: 강력한 이미지 인식 모델(Yolo v5)과 사용자 친화적인 인터페이스(Flutter 앱) 이용하기, 안드로이드 기반 애플리케이션 구현
- 

**2.2 시스템 설계**
- **구조 설계:** Yolo v5 모델을 통해 이미지를 처리하고, 플러터 앱을 통해 결과를 사용자에게 제공하는 구조 설계.
- **데이터 흐름:** 사용자가 입력한 이미지를 서버로 전송 → 서버에서 Yolo v5 모델로 재료 인식 → 인식된 재료 정보를 데이터베이스와 비교하여 레시피 추천 → 플러터 앱에서 결과 표시.


**2.3 모델 학습**
- **데이터 수집:** 다양한 음식 재료 이미지 데이터셋 수집. dataset은 구글 드라이브에 링크로 추가 예정

링크 : 

- **데이터 전처리:** 이미지 정규화, 크기 조정, 라벨링 등 데이터 전처리 작업 수행.
- **모델 학습:** Yolo v5 모델을 사용하여 학습. 학습 과정에서는 전이 학습을 활용하여 모델의 인식 성능을 높임.
- **모델 평가:** 학습된 모델을 검증 데이터셋으로 평가하여 정확도 및 성능 측정.



- **모델 아키텍처:** Yolo v5의 구조 및 설정 파라미터 조정.
- **전이 학습:** ImageNet 등 대형 데이터셋으로 사전 학습된 모델을 활용하여 학습 속도 및 성능 향상.
- **하이퍼파라미터 튜닝:** 학습률, 배치 크기 등 하이퍼파라미터 최적화.






**3.3 모델 학습 및 검증**
- **훈련 과정:** GPU를 활용한 모델 훈련, 훈련 과정에서의 손실값 및 정확도 모니터링.
- **검증 및 테스트:** 검증 데이터셋을 통해 모델의 성능 평가, F1-score, Precision, Recall 등의 지표 사용.
- **모델 개선:** 검증 결과를 바탕으로 모델 구조 및 하이퍼파라미터 조정.





