# iOS에서 네트워크 구현하기

## URLSession

- iOS에서 HTTP 통신을 도와주는 도구. Foundation에서 제공.
- 알아둬야 할 것
  - [`URLSessionConfiguration`](https://developer.apple.com/documentation/foundation/urlsessionconfiguration): URLSession에 대한 설정
    - `.default`: 기본적인 작업
    - `.ephemeral`: 캐시, 쿠키, 인증정보 등을 저장하지 않음 (ephemeral 이퍼미럴: 단명하는)
    - `.background`: 앱이 백그라운드에서 돌고 있어도 다운로드 가능
  - [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession): URLSessionConfiguration에 대한 세션을 생성
  - [`URLSessionTask`](https://developer.apple.com/documentation/foundation/urlsessiontask): URLSession에서 만든 네트워크 작업
    - `URLSession::dataTask(with:)`: URLSessionDataTask instances 생성. 데이터를 요청하고 받아옴.
    - `URLSession::uploadTask(with:from:)`: URLSessionUploadTask instances 생성. 데이터를 서버에 업로드함.
    - `URLSession::downloadTask(with:)`: URLSessionDownloadTask instances 생성. 다운로드한 데이터 저장.

  ![](imgs/URLSessionTask.webp)

## [Codable](https://developer.apple.com/documentation/swift/codable)

- 대부분 네트워크 요청/응답 바디 형태는 JSON을 사용
- Swift 객체 <-> JSON 간 인코딩, 디코딩을 쉽게 할 수 있도록 도와주는 타입
- 참고자료
  - [Using JSON with Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/using_json_with_custom_types)
  - [Encoding and Decoding Custom Types](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)

## URLSession + Combine

- Combine 등장 이후, URLSession과 Combine을 같이 이용할 수 있도록 `URLSessionDataTask`에 대한 publisher 제공 ([참고](https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine))
- 응답을 비동기적으로 처리하기 더 쉬워짐

## 실습 1 - Playground

[code](../projects/Network%20in%20iOS.playground)

## 실습 2 - 프로젝트 깃헙
