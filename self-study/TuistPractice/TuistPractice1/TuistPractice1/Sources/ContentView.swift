import SwiftUI
import Gil

public struct ContentView: View {
    public init() {}

    public var body: some View {
        let a = TestGil()
        Text("Hello, World!")
            .padding()
    }
}

#Preview {
    ContentView()
}
