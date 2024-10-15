# GoRouterWatcher

GoRouterWatcher는 Flutter 애플리케이션에서 go_router를 사용할 때 라우트 변경을 추적하고 로깅하는 유틸리티 클래스입니다.

## 주요 기능

- 라우트 변경 감지
- 이전 라우트와 현재 라우트 정보 추적
- 라우트 체류 시간 계산
- 전체 경로 추적
- 커스텀 로깅 기능

## 사용법

1. GoRouterWatcher 초기화:

```dart
void main() {
  final GoRouter router = GoRouter(
    // 라우트 설정
  );

  GoRouterWatcher.instance.initialize(
    router,
    log: (RouteLog log) {
      print(log.toString());
    },
  );

  runApp(MyApp(router: router));
}
```

## RouteLog 클래스
RouteLog 클래스는 라우트 변경 정보를 담고 있습니다. 다음 정보를 포함합니다:

- route: 현재 라우트
- previousRoute: 이전 라우트
- fullPath: 전체 경로
- duration: 이전 라우트에서의 체류 시간

## 주의사항
GoRouterWatcher는 싱글톤 패턴을 사용합니다. GoRouterWatcher.instance를 통해 접근하세요.

반드시 initialize 메서드를 호출하여 GoRouter 인스턴스를 설정해야 합니다.