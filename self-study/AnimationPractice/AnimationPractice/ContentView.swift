import SwiftUI

struct ContentView: View {
    // 애니메이션 효과를 위한 상태 변수들입니다.
    @State private var isAnimated = false

    var body: some View {
        VStack {
            Spacer()

            // 이 사각형의 위치, 크기, 색상 등을 변경해볼 것입니다.
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .offset(y: isAnimated ? -200 : 0)

            Spacer()

            Button("Animate") {
                // 이 버튼을 눌렀을 때 애니메이션이 동작하도록 코드를 추가합니다.
                withAnimation {
                    self.isAnimated.toggle()
                }
            }
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    ContentView()
}
