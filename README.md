# AppStore Clone 프로젝트 
> [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1)를 통해 `앱 ID` 검색 결과를 상세 화면에 나타냅니다.

- Deployment Target : iOS 13.0
- Architecture : MVVM-C
- 프레임워크 : Combine
- 참고 - [코딩/커밋 컨벤션](https://www.notion.so/Code-Commit-Convention-6abe6dd43c574e949fe15ea5fb3681e2)

## Foldering
```
AppStoreClone
├── App
├── Presentation
│   ├── LookupScene
│   │   ├── ViewModel
│   │   └── View      
│   ├── DetailScene
│   │   ├── ViewModel
│   │   └── View   
│   └── ScreenshotScene
│       ├── ViewModel
│       └── View  
├── Model
├── Network
│   └── Response
├── Protocols
├── Extensions
├── Utilities
└── Resources
AppStoreCloneTests
└── Mock
```

## 추가 구현한 기능 ✅
- 코드로 UI를 구현했습니다.
- `MockURLSession`을 활용한 네트워크 테스트 등 테스트 코드를 작성했습니다.
- 상세화면에서 `SummaryScrollView`를 구현하여 평점, 연령, 카테고리 등 주요 정보를 나타냈습니다.
- 앱 평점을 `별 이미지`로 나타냈고, 평가 개수를 `천/만` 단위로 환산하여 보여줍니다.
- 상세화면 하단의 정보 항목을 `InfoTableView`로 구현하여 앱의 세부정보를 나타냈습니다.
- 이미지 `Cache`를 구현했습니다.
- `가로/세로 모드` 전환에 대응했습니다.
- `다크/라이트 모드` 전환에 대응했습니다.

# 목차
- Feature-1. 네트워크 및 검색화면 구현
    + [주요 기능](#1-1-주요-기능)
    + [구현 내용](#1-2-구현-내용)
- Feature-2. 상세화면 구현
    + [주요 기능](#2-1-주요-기능)
    + [구현 내용](#2-2-구현-내용)
- [구현 화면](#구현-화면)
- [보완할 점](#보완할-점)


# Feature-1. 네트워크 및 검색화면 구현
## 1-1 주요 기능
- 사용자가 `TextField`에 입력한 `앱 ID`를 통해 서버에서 앱 정보를 받아옵니다.
- 앱 ID가 유효하지 않으면 Label에 나타냅니다.
- `URLSession`을 통해 네트워크 통신을 구현했습니다. (`MockURLSession`을 통한 테스트 실행)

## 1-2 구현 내용
### 1. MVVM-C 적용
`Coordinator`를 통해 의존성 주입을 관리하고, 화면전환 역할을 전담하도록 했습니다. 이를 위해 `navigationController`를 `생성자 주입`으로 하위 ChildCoordinator에 전달하고, 화면전환 시 해당 `navigationController`가 다음 화면을 push 하도록 했습니다.

`검색화면 -> 상세화면 -> 스크린샷 확대 화면` 순으로 연결되므로 각 상위 Coordinator의 `childCoordinators`에 하위 Coordinator를 추가했습니다. 이때 메모리 관리를 위해 하위 화면이 pop될 때, ViewModel의 `deinit`에서 해당 Coordinator가 finish되도록 설정했습니다. 또한 `Delegate 패턴`을 적용하여 상위 Coordinator가 `removeFromChildCoordinators(coordinator:)`를 호출하여 하위 Coordinator가 childCoordinator에서 제거하도록 했습니다.

`Debug Memory Graph`를 통한 디버깅으로 Coordinator/ViewModel 등이 메모리에서 정상적으로 해제되는지 확인했습니다.

### 2. 네트워크 구현 및 API 추상화
비동기 작업을 처리하기 위해 `Combine` 프레임워크를 활용했습니다. 서버에서 받아온 데이터는 `Publisher` 타입으로 반환하고, ViewModel 및 ViewController를 `Binding`하여 화면에 나타내도록 구현했습니다. 또한 사용자 이벤트를 처리하기 위해 ViewController에서 `PassthroughSubject` 타입을 활용했습니다.

또한 API를 `열거형`으로 관리하는 경우, API를 추가할 때마다 새로운 case가 필요하여 열거형이 비대해지고, 열거형 관련 switch문을 매번 수정해야 하는 번거로움이 있었습니다. 따라서 API를 `구조체` 타입으로 변경하고, URL 프로퍼티 외에도 `HttpMethod` 프로퍼티를 추가한 `APIProtocol` 타입을 채택하도록 개선했습니다. 해당 구조는 코드 유지보수가 용이하며, 협업 시 팀원이 각자 담당한 API 구조체 타입을 독립적으로 관리하여 충돌을 방지할 수 있다는 장점이 있습니다.

### 3. MockURLSession을 통한 네트워크 테스트
아래의 목적을 위해 `MockURLSession`을 구현했습니다.
- 실제 서버와 통신할 경우 테스트의 속도가 느려짐
- 인터넷 연결상태에 따라 테스트 결과가 달라지므로 테스트 신뢰도가 떨어짐
- 실제 서버와 통신을 하며 서버에 테스트 데이터가 불필요하게 업로드되는 Side-Effect가 발생함

또한 향후 테스트 대상 파일이 늘어날 것에 대비하여 Mock 데이터로 `JSON` 파일을 추가하고, `Bundle(for: type(of: self))`로 데이터에 접근했습니다.

# Feature-2. 상세화면 구현
## 2-1 주요 기능
- AppStore의 앱 소개 페이지와 유사한 디자인으로 구현했습니다.
- 화면 요소를 `Main`, `Summary ScrollView`, `Screenshot CollectionView`, `Description Label`, `Info TableView`로 나누어 구현했습니다.
- 앱의 스크린샷 이미지를 `CollectionView`로 보여주고, Cell을 탭하면 이미지를 크게볼 수 있는 화면을 나타냅니다.
- 앱 설명 영역의 `펼치기 버튼`을 탭하면 설명이 펼쳐집니다. 펼쳐진 상태에서 `접기 버튼`을 탭하면 다시 설명이 줄어듭니다.

## 2-2 구현 내용
### 1. Summary ScrollView 및 Vertical Separator 구현
ScrollView 내부에 `ContainerStackView`를 추가하고, 그 내부에 별점/연령/카테고리/개발자/언어 등 각 항목의 StackView를 추가했습니다. 이때 각 항목을 `EqualSpacing`으로 배치해야 했으므로 `Separator`를 ContainerStackView에 넣으면 Layout이 깨지는 문제가 있었습니다.

따라서 `StackView Extension`을 통해 ArrangedSubview가 아닌 `Subview`에 Separator를 넣고, 기존 컨텐츠의 `trailingAnchor` 위치에 Separator를 배치하여 문제를 해결했습니다.

```swift
func addVerticalSeparators(color: UIColor = .systemGray3, heightRatio: CGFloat = 0.5, spacing: CGFloat = 0) {
    let separatorCount = arrangedSubviews.count - 1

    (0..<separatorCount).forEach { index in
        guard let subview = subviews[safe: index] else { return }

        let separatorView = createVerticalSeparatorView(color: color)
        addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightRatio),
            separatorView.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: spacing),
            separatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
```

### 2. 평점을 이미지뷰로 표시하는 StarRatingStackView 구현
별점을 나타낼 `StarImageView` 종류를 filled/halfFilled/empty로 구분했고,
평점 데이터를 받아 필요한 개수만큼 종류별 ImageView를 생성하여 StackView에 추가하도록 했습니다. 아래 로직과 같이 정수를 뺀 소수점 영역의 값이 0.5 이상이면 `halfFilledStar` 이미지뷰가 1개 생성되도록 했습니다.
```swift
private func configureStarImageView(with rating: Double) -> [StarImageView] {
    let starCountByKind = calculateStarCountByKind(with: rating)

    var starImageViews = [StarImageView]()
    starImageViews += (0..<starCountByKind.filled).map { _ in StarImageView(kind: .filled) }
    starImageViews += (0..<starCountByKind.halfFilled).map { _ in StarImageView(kind: .halfFilled) }
    starImageViews += (0..<starCountByKind.empty).map { _ in StarImageView(kind: .empty) }

    return starImageViews
}

private func calculateStarCountByKind(with rating: Double) -> (filled: Int, halfFilled: Int, empty: Int) {
    let filledStarCount = Int(rating)

    let remainder = rating.truncatingRemainder(dividingBy: 1)
    let halfFilledStarCount = remainder >= 0.5 ? 1 : 0

    let emptyStarCount = maxStarCount - filledStarCount - halfFilledStarCount

    return (filledStarCount, halfFilledStarCount, emptyStarCount)
}
```

### 3. ScreenshotCollectionView 구현
상세화면 및 스크린샷 확대 화면에서 CollectionView의 `Compositional Layout`을 활용하여 Cell을 배치했습니다. 두 화면의 Cell 구성이 같으므로 모두 ScreenshotCell을 사용했습니다. 

Section의 orthogonalScrollingBehavior는 각각 `groupPaging`, `groupPagingCentered`으로 설정하여 AppStore와 동일하게 Pagination을 구현했습니다.

# 구현 화면
|검색 화면|상세 화면|가로/세로 모드 대응|다크/라이드 모드 대응|
|-|-|-|-|
|<img src="https://user-images.githubusercontent.com/70856586/183929888-ea834416-dda6-4071-8c75-61d69c4831fe.gif" width="200">|<img src="https://user-images.githubusercontent.com/70856586/183929947-a44d6eff-9f8d-4407-9a03-5c449a0a133f.gif" width="200">|<img src="https://user-images.githubusercontent.com/70856586/183930026-de70eedc-2e5f-4fa5-a9d7-9bfad8cfe5ba.gif" width="200">|<img src="https://user-images.githubusercontent.com/70856586/183930057-3347736f-1e5e-4b6e-83e5-a0d9ee6a05ed.gif" width="200">|

# 보완할 점
- SummaryScrollView에서 카테고리 종류에 따라 ImageView를 변경하는 기능을 추가 구현할 예정입니다.
- Localization을 추가 구현할 예정입니다. (SummaryScrollView의 언어, 카테고리명, InfoTableView의 언어 항목 등)
- Quick/Numble을 활용하여 ViewModel 테스트 코드를 진행할 예정입니다.
- 리뷰 노트 : Lookup API 특성상 서버 데이터 중 평가 개수 (userRatingCount), 앱 크기 (fileSize) 등이 실제 AppStore에서 확인되는 값과 일치하지 않는 경우가 있습니다.
