import SwiftUI

// 1. 애니메이션에 사용할 값들을 정의하는 구조체 (선택 사항이지만 권장됨)
struct AnimationValues {
  var offsetX: CGFloat = 0
  var offsetY: CGFloat = 0
  var scale: CGFloat = 1.0
}

struct TestView3: View {
  // 2. 애니메이션을 발동시킬 트리거
  @State private var trigger = false

  var body: some View {
    Text("👋 흔들흔들")
      .font(.largeTitle)
      // 3. Keyframe Animator 적용
      .keyframeAnimator(
        initialValue: AnimationValues(),  // 4. 초기값 설정
        trigger: trigger  // 5. 트리거 연결
      ) { view, values in
        // 6. 계산된 값을 뷰에 적용
        view
          .scaleEffect(values.scale)
          .offset(x: values.offsetX, y: values.offsetY)
      } keyframes: { values in
        // 7. 키프레임 정의
        // KeyframeTrack으로 각 속성별 애니메이션을 정의
        KeyframeTrack(\.offsetX) {
          LinearKeyframe(0, duration: 0.1)  // 0.1초 동안 0
          LinearKeyframe(20, duration: 0.1)  // 0.1초 동안 20
          LinearKeyframe(-20, duration: 0.1)  // 0.1초 동안 -20
          LinearKeyframe(0, duration: 0.1)  // 0.1초 동안 0
        }
        
        KeyframeTrack(\.offsetY) {
          LinearKeyframe(0, duration: 0.1)  // 0.1초 동안 0
          LinearKeyframe(-30, duration: 0.1)  // 0.1초 동안 20
          LinearKeyframe(28, duration: 0.1)  // 0.1초 동안 -20
          LinearKeyframe(0, duration: 0.1)  // 0.1초 동안 0
        }

        // 동시에 다른 속성도 애니메이션 가능
        KeyframeTrack(\.scale) {
          CubicKeyframe(1.2, duration: 0.1)  // 0.1초 동안 1.2배
          CubicKeyframe(1.0, duration: 0.3)  // 0.3초 동안 다시 1.0배
        }
      }
      .onTapGesture {
        // 8. 탭할 때마다 트리거 값 변경
        trigger.toggle()
      }
  }
}

#Preview {
  TestView3()
}
