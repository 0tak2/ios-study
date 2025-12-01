# SwiftUI Animation Workbook

이 워크북은 SwiftUI 애니메이션의 기본 개념을 실습을 통해 학습하기 위해 만들어졌습니다. 각 단계를 따라 `AnimationPractice/ContentView.swift` 파일을 수정하며 애니메이션이 어떻게 동작하는지 직접 확인해보세요.

---

### 시작하기: 준비된 코드 확인

먼저 `ContentView.swift` 파일이 아래와 같이 준비되었는지 확인하세요. 파란색 사각형 하나와 "Animate" 버튼이 화면에 표시될 것입니다.

```swift
import SwiftUI

struct ContentView: View {
    @State private var isAnimated = false

    var body: some View {
        VStack {
            Spacer()

            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .offset(y: isAnimated ? -200 : 0)

            Spacer()

            Button("Animate") {
                self.isAnimated.toggle()
            }
            .padding(.bottom, 50)
        }
    }
}
```

현재 상태에서는 "Animate" 버튼을 눌러도 사각형이 즉시 위/아래로 순간이동할 것입니다. 이제 이 움직임을 부드럽게 만들어 보겠습니다.

---

### 실습 1: 암시적 애니메이션 (Implicit Animation)

**목표:** `.animation()` 수식어(modifier)를 사용하여 사각형의 위치 변경에 애니메이션을 적용합니다.

**진행할 내용:**

`ContentView.swift` 파일에서 `Rectangle`에 `.animation()` 수식어를 추가하세요. `offset`이 변경될 때마다 이 수식어가 애니메이션 효과를 적용해 줄 것입니다.

**수정할 코드 (`Rectangle` 부분):**

```swift
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .offset(y: isAnimated ? -200 : 0)
                // 아래에 코드를 추가하여 애니메이션을 적용해보세요.
                /* YOUR CODE HERE */
```

**힌트:** `.animation(.default, value: isAnimated)` 와 같은 코드를 추가해보세요. `value`는 어떤 상태가 변경될 때 애니메이션을 적용할지 알려주는 중요한 파라미터입니다.

---

### 실습 2: 다양한 애니메이션 효과 적용하기

**목표:** 여러 가지 내장 애니메이션 효과(easing)를 경험하고 차이를 이해합니다.

**진행할 내용:**

실습 1에서 추가했던 `.animation()` 수식어의 파라미터를 변경하여 다양한 느낌의 애니메이션을 만들어 보세요.

**수정할 코드:**

```swift
// 아래 코드들을 하나씩 적용해보며 차이를 느껴보세요.
.animation(.easeInOut(duration: 1), value: isAnimated) // 1초 동안 부드럽게
// .animation(.linear(duration: 1), value: isAnimated) // 등속으로 움직임
// .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: isAnimated) // 용수철처럼 통통 튀는 효과
```

---

### 실습 3: 여러 속성을 동시에 애니메이션하기

**목표:** 위치뿐만 아니라 크기, 색상 등 여러 속성을 동시에 변경하고 애니메이션을 적용합니다.

**진행할 내용:**

1.  `ContentView`에 `scale`과 `color`를 위한 `@State` 변수를 추가합니다.
2.  버튼을 눌렀을 때 `isAnimated`와 함께 이 변수들의 값도 변경되도록 로직을 추가합니다.
3.  `Rectangle`에 `.scaleEffect()`와 `.foregroundColor()` 수식어를 수정하여 새로운 상태 변수와 연결합니다.

**수정할 코드 (`ContentView.swift` 전체):**

아래 코드에서 `/* YOUR CODE HERE */` 부분을 채워 전체 코드를 완성해보세요.

```swift
import SwiftUI

struct ContentView: View {
    @State private var isAnimated = false
    // 크기와 색상을 위한 상태 변수를 추가하세요.
    /* YOUR CODE HERE */

    var body: some View {
        VStack {
            Spacer()

            Rectangle()
                // 상태 변수를 사용하여 색상을 지정하세요.
                /* YOUR CODE HERE */
                .frame(width: 100, height: 100)
                // 상태 변수를 사용하여 크기를 조절하세요.
                /* YOUR CODE HERE */
                .offset(y: isAnimated ? -200 : 0)
                .animation(.spring(), value: isAnimated)


            Spacer()

            Button("Animate") {
                self.isAnimated.toggle()
                // isAnimated 값에 따라 색상과 크기를 변경하는 코드를 추가하세요.
                /* YOUR CODE HERE */
            }
            .padding(.bottom, 50)
        }
    }
}
```

---

### 실습 4: 명시적 애니메이션 (Explicit Animation)

**목표:** `.animation()` 수식어 대신 `withAnimation` 클로저를 사용하여 애니메이션을 적용합니다.

**진행할 내용:**

1.  `Rectangle`에 적용했던 `.animation()` 수식어를 모두 제거합니다.
2.  `Button`의 action 내부에서 상태를 변경하는 코드를 `withAnimation` 클로저로 감싸줍니다.

**수정할 코드 (`Button` 부분):**

```swift
            Button("Animate") {
                // withAnimation 블록으로 상태 변경을 감싸 애니메이션을 적용하세요.
                /* YOUR CODE HERE */
                self.isAnimated.toggle()
                // ... 다른 상태 변경 코드들
            }
```

**힌트:** `withAnimation(.easeInOut(duration: 1)) { ... }` 와 같은 형태로 코드를 작성합니다.

이 실습들을 통해 SwiftUI 애니메이션의 기본적인 두 가지 접근 방식을 모두 경험할 수 있습니다. 직접 코드를 수정하고 실행하며 결과를 확인해보세요!