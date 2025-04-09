import SwiftUI
import PlaygroundSupport

struct PositionVsOffsetView2: View {
    @State var renderPositionExample = false
    
    var body: some View {
        VStack {
            if renderPositionExample {
                Text("Hello, world!")
                    .background(.red)
                    .position(x: 100, y: 100)
                    .border(Color.blue)
            } else {
                Text("Hello, world!")
                    .background(.red)
                    .offset(x: 100, y: 100)
                    .border(Color.blue)
            }
            
            Text(renderPositionExample ? "used .position" : "used .offset")
            
            Button {
                renderPositionExample.toggle()
            } label: {
                Image(systemName: "arrow.trianglehead.clockwise")
            }
        }
        .frame(width: 512, height: 512)
        .background(Color.orange)
    }
}

PlaygroundPage.current.setLiveView(PositionVsOffsetView2())
