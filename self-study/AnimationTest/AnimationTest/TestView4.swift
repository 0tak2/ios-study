import SwiftUI

// 1. 애니메이션에 사용할 값들을 정의하는 구조체
struct HardcodedAnimationValues {
    var scale: CGFloat = 1.0
    var degree: Double = 0.0
    var offsetX: CGFloat = 0.0
    var offsetY: CGFloat = 0.0
}

struct TestView4: View {
    @State private var trigger = false
    
    // 30fps = 1프레임당 약 0.0333...초
    let frameDuration = 1.0 / 30.0

    var body: some View {
        // 애니메이션을 적용할 뷰
        Image(systemName: "star.fill")
            .font(.system(size: 100))
            .foregroundStyle(.yellow)
            .keyframeAnimator(
                // 2. 초기값 설정
                initialValue: HardcodedAnimationValues(),
                // 3. 애니메이션을 발동시킬 트리거
                trigger: trigger
            ) { view, values in
                // 4. 계산된 값을 뷰에 적용
                view
                    .scaleEffect(values.scale)
                    .rotationEffect(.degrees(values.degree))
                    .offset(x: values.offsetX, y: values.offsetY)
            } keyframes: { _ in
                
                // 5. === 30fps 템플릿 시작 ===
                // 각 트랙은 정확히 30개의 1/30초 키프레임을 가집니다.

                // --- 스케일 (Scale) 트랙 (30 frames) ---
                KeyframeTrack(\.scale) {
                    // Frames 1-5
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 1
                    LinearKeyframe(1.2, duration: frameDuration) // Frame 2
                    LinearKeyframe(0.9, duration: frameDuration) // Frame 3
                    LinearKeyframe(1.1, duration: frameDuration) // Frame 4
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 5
                    // Frames 6-10
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 6
                    LinearKeyframe(1.2, duration: frameDuration) // Frame 7
                    LinearKeyframe(0.9, duration: frameDuration) // Frame 8
                    LinearKeyframe(1.1, duration: frameDuration) // Frame 9
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 10
                    // Frames 11-15
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 11
                    LinearKeyframe(1.2, duration: frameDuration) // Frame 12
                    LinearKeyframe(0.9, duration: frameDuration) // Frame 13
                    LinearKeyframe(1.1, duration: frameDuration) // Frame 14
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 15
                    // Frames 16-20
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 16
                    LinearKeyframe(1.2, duration: frameDuration) // Frame 17
                    LinearKeyframe(0.9, duration: frameDuration) // Frame 18
                    LinearKeyframe(1.1, duration: frameDuration) // Frame 19
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 20
                    // Frames 21-25
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 21
                    LinearKeyframe(1.2, duration: frameDuration) // Frame 22
                    LinearKeyframe(0.9, duration: frameDuration) // Frame 23
                    LinearKeyframe(1.1, duration: frameDuration) // Frame 24
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 25
                    // Frames 26-30
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 26
                    LinearKeyframe(1.2, duration: frameDuration) // Frame 27
                    LinearKeyframe(0.9, duration: frameDuration) // Frame 28
                    LinearKeyframe(1.1, duration: frameDuration) // Frame 29
                    LinearKeyframe(1.0, duration: frameDuration) // Frame 30
                }
                
                // --- 회전 (Degree) 트랙 (30 frames) ---
                KeyframeTrack(\.degree) {
                    // Frames 1-5
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 1
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 2
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 3
                    LinearKeyframe(5.0, duration: frameDuration)   // Frame 4
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 5
                    // Frames 6-10
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 6
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 7
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 8
                    LinearKeyframe(5.0, duration: frameDuration)   // Frame 9
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 10
                    // Frames 11-15
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 11
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 12
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 13
                    LinearKeyframe(5.0, duration: frameDuration)   // Frame 14
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 15
                    // Frames 16-20
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 16
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 17
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 18
                    LinearKeyframe(5.0, duration: frameDuration)   // Frame 19
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 20
                    // Frames 21-25
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 21
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 22
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 23
                    LinearKeyframe(5.0, duration: frameDuration)   // Frame 24
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 25
                    // Frames 26-30
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 26
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 27
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 28
                    LinearKeyframe(5.0, duration: frameDuration)   // Frame 29
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 30
                }
                
                // --- X축 이동 (OffsetX) 트랙 (30 frames) ---
                KeyframeTrack(\.offsetX) {
                    // Frames 1-5
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 1
                    LinearKeyframe(15.0, duration: frameDuration)  // Frame 2
                    LinearKeyframe(-15.0, duration: frameDuration) // Frame 3
                    LinearKeyframe(8.0, duration: frameDuration)   // Frame 4
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 5
                    // Frames 6-10
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 6
                    LinearKeyframe(15.0, duration: frameDuration)  // Frame 7
                    LinearKeyframe(-15.0, duration: frameDuration) // Frame 8
                    LinearKeyframe(8.0, duration: frameDuration)   // Frame 9
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 10
                    // Frames 11-15
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 11
                    LinearKeyframe(15.0, duration: frameDuration)  // Frame 12
                    LinearKeyframe(-15.0, duration: frameDuration) // Frame 13
                    LinearKeyframe(8.0, duration: frameDuration)   // Frame 14
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 15
                    // Frames 16-20
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 16
                    LinearKeyframe(15.0, duration: frameDuration)  // Frame 17
                    LinearKeyframe(-15.0, duration: frameDuration) // Frame 18
                    LinearKeyframe(8.0, duration: frameDuration)   // Frame 19
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 20
                    // Frames 21-25
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 21
                    LinearKeyframe(15.0, duration: frameDuration)  // Frame 22
                    LinearKeyframe(-15.0, duration: frameDuration) // Frame 23
                    LinearKeyframe(8.0, duration: frameDuration)   // Frame 24
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 25
                    // Frames 26-30
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 26
                    LinearKeyframe(15.0, duration: frameDuration)  // Frame 27
                    LinearKeyframe(-15.0, duration: frameDuration) // Frame 28
                    LinearKeyframe(8.0, duration: frameDuration)   // Frame 29
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 30
                }
                
                // --- Y축 이동 (OffsetY) 트랙 (30 frames) ---
                KeyframeTrack(\.offsetY) {
                    // Frames 1-5
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 1
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 2
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 3
                    LinearKeyframe(-5.0, duration: frameDuration)  // Frame 4
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 5
                    // Frames 6-10
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 6
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 7
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 8
                    LinearKeyframe(-5.0, duration: frameDuration)  // Frame 9
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 10
                    // Frames 11-15
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 11
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 12
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 13
                    LinearKeyframe(-5.0, duration: frameDuration)  // Frame 14
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 15
                    // Frames 16-20
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 16
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 17
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 18
                    LinearKeyframe(-5.0, duration: frameDuration)  // Frame 19
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 20
                    // Frames 21-25
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 21
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 22
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 23
                    LinearKeyframe(-5.0, duration: frameDuration)  // Frame 24
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 25
                    // Frames 26-30
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 26
                    LinearKeyframe(-10.0, duration: frameDuration) // Frame 27
                    LinearKeyframe(10.0, duration: frameDuration)  // Frame 28
                    LinearKeyframe(-5.0, duration: frameDuration)  // Frame 29
                    LinearKeyframe(0.0, duration: frameDuration)   // Frame 30
                }
                // === 템플릿 끝 ===
            }
            .onTapGesture {
                // 뷰를 탭하면 trigger 값이 바뀌면서 애니메이션이 다시 실행됩니다.
                trigger.toggle()
            }
            .padding(100) // 탭하기 쉽게 여백 추가
    }
}

#Preview {
  TestView4()
}
