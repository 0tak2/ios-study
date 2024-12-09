import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @State var title: String = "플레이그라운드 테스트"
    @State var count: Int = 0
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            Button(action: {
                count += 1
                
                if count == 1 {
                    self.title = "버튼을 눌렀구나?"
                } else {
                    self.title = "버튼을 \(count)번 눌렀어!"
                }
            }, label: {
                Text("안녕")
            })
        }
        .padding()
    }
}
PlaygroundPage.current.setLiveView(ContentView())
