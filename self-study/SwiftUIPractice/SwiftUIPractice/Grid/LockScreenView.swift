//
//  LockScreenView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 4/27/25.
//

import SwiftUI

// FIXME: 실제 기기나 시뮬레이터로 띄워보면 0번, 3번 열이 블러리하게 보임. 프리뷰는 괜찮음.
// -> FIXED
// 배경 이미지의 프레임을 GeometryReader를 이용해 스크린 사이즈에 맞게 명시적으로 정의했더니
// VStack, HStack 너비 문제와 함께 블러리되는 이슈도 사라졌음
// 왜..?
struct LockScreenView: View {
    let passwordAnswer: String = "123456" // 정답
    @State var passwordInput: String = ""
    @State var isCorrect: Bool = false
    @State var shakeOffset: CGFloat = 0
    
    var body: some View {
        if isCorrect {
            backgroundImage
        } else {
            ZStack {
                // MARK: 배경 이미지
                backgroundImage
                    .blur(radius: 8)
                
                // MARK: 암호 입력 폼
                VStack(spacing: 0) {
                    VStack {
                        Text("암호 입력")
                            .font(.title2)
                            .foregroundStyle(.white)
                        
                        HStack(spacing: 24) {
                            ForEach(0..<passwordAnswer.count, id: \.self) { idx in
                                Image(systemName: idx < passwordInput.count ? "circle.fill" : "circle")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(.white)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        .offset(x: shakeOffset) // MARK: ChatGPT 참고함 - SwiftUI에서 좌우로 빠르게 흔들리고 정지하는 애니메이션을 주려면 어떡해?
                    }
                    .padding(.vertical, 72)
                    
                    // TODO: 꼭 Grid여야만 하나? VStack + HStack으로는 안되나? 어떤 방식이 더 좋은가?
                    Grid(horizontalSpacing: 24, verticalSpacing: 16) {
                        ForEach([1, 4, 7], id: \.self) { startNumber in
                            GridRow {
                                ForEach(startNumber..<startNumber+3, id: \.self) { number in
                                    dialButton(number, didTap: dialButtonTapped)
                                }
                            }
                        }
                        
                        GridRow {
                            Circle()
                                .fill(.clear)
                                .frame(width: 80, height: 80)
                            
                            dialButton(0, didTap: dialButtonTapped)
                            
                            Circle()
                                .fill(.clear)
                                .frame(width: 80, height: 80)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            //
                        } label: {
                            Text("긴급 상황")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)

                        Button { // FIXME: Duplicated styling
                            //
                        } label: {
                            Text("취소")
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
    }
    
    private var backgroundImage: some View {
        GeometryReader { proxy in
            Image("LockScreenBackground")
                .resizable()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .aspectRatio(contentMode: .fill)
                .scaleEffect(1.4)
                .edgesIgnoringSafeArea(.all)
        }
        
        // 이렇게 자르지 않으면 사이드 이펙트 발생
        // VStack, HStack의 너비가 이미지를 따라 화면 밖으로 넘친다
        // 다이얼 버튼 0번, 2번 행이 블러리해진다 => 이유는 잘 모르겠다
//        Image("LockScreenBackground")
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .scaleEffect(1.4)
//            .edgesIgnoringSafeArea(.all)
    }
    
    private func handlePasswordInput(newNumber: Int) {
        passwordInput += String(newNumber)
        
        if passwordInput.count == passwordAnswer.count {
            if passwordInput == passwordAnswer {
                print("corrct")
                isCorrect = true
            } else {
                print("wrong")
                shake()
            }
            
            passwordInput = ""
        }
    }
    
    private func dialButtonTapped(_ number: Int) {
        print("\(number) pressed")
        handlePasswordInput(newNumber: number)
        print("current input: \(passwordInput)")
    }
    
    // MARK: ChatGPT 참고함 - SwiftUI에서 좌우로 빠르게 흔들리고 정지하는 애니메이션을 주려면 어떡해?
    private func shake() {
        let baseAnimation = Animation.linear(duration: 0.05)
        let repeatCount = 5

        withAnimation(baseAnimation.repeatCount(repeatCount, autoreverses: true)) {
            shakeOffset = 10
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (0.05 * Double(repeatCount))) {
            shakeOffset = 0
        }
    }
    
    // TODO: 비밀번호 틀렸을 때 토도독 하는 복잡한 진동 효과를 주려면?
    
    @ViewBuilder
    func dialButton(_ number: Int, didTap: @escaping (_ number: Int) -> Void) -> some View {
        let supplementaryTexts: [Int: String] = [
            1: "",
            2: "ABC",
            3: "DEF",
            4: "GHI",
            5: "JKL",
            6: "MNO",
            7: "PQRS",
            8: "TUV",
            9: "WXYZ",
            0: "",
        ]
        
        Button {
            didTap(number)
        } label: {
            VStack {
                Text(String(number))
                    .font(.title)
                    .fontWeight(.medium)
                
                if let supplementaryText = supplementaryTexts[number],
                   number != 0 {
                    Text(supplementaryText)
                        .tracking(2) // 뒤따라오는 자간을 조절한다
                        .font(.footnote)
                        .fontWeight(.bold)
                }
            }
            .foregroundStyle(.white)
            .frame(width: 80, height: 80)
            .background(.white.opacity(0.3))
            .clipShape(Circle())
        }
    }
}

#Preview {
    LockScreenView()
}
