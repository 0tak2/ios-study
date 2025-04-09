import SwiftUI
import PlaygroundSupport

struct PositionVsOffsetView: View {
    @State var xPos: CGFloat = 0.0
    @State var yPos: CGFloat = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .opacity(0.5)
                    .frame(width: 100, height: 100)
                    .position(x: xPos, y: yPos) // 뷰의 가운데 점을 부모 뷰의 특정 좌표에 둔다.
                    .border(Color.black)
                    
                
                Rectangle()
                    .fill(Color.blue)
                    .opacity(0.5)
                    .frame(width: 100, height: 100)
                    .offset(x: xPos, y: yPos) // 지정한 세로, 가로 거리 만큼 오프셋을 둔다 (옮긴다)
                    .border(Color.black)
            }
            
            HStack {
                Button {
                    xPos -= 10.0
                } label: {
                    Image(systemName: "arrow.left")
                }

                Button {
                    yPos -= 10.0
                } label: {
                    Image(systemName: "arrow.up")
                }
                
                Button {
                    yPos += 10.0
                } label: {
                    Image(systemName: "arrow.down")
                }
                
                Button {
                    xPos += 10.0
                } label: {
                    Image(systemName: "arrow.right")
                }
            }
            
            Text("xPos: \(Int(xPos)), yPos: \(Int(yPos))")
        }
        .background(Color.orange)
        .frame(width: 512, height: 512)
    }
}

PlaygroundPage.current.setLiveView(PositionVsOffsetView())
