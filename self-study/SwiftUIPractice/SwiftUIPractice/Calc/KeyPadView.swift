//
//  KeyPadView.swift
//  SwiftUIPractice
//
//  Created by 임영택 on 5/18/25.
//

import SwiftUI

struct KeyPadView: View {
    var body: some View {
        Grid {
            GridRow {
                createKeyButton(label: "AC", keyType: .control) {
                    print("AC")
                }
                
                createKeyButton(systemImageName: "plus.forwardslash.minus", keyType: .control) {
                    print("+/-")
                }
                
                createKeyButton(label: "%", keyType: .control) {
                    print("%")
                }
                
                createKeyButton(label: "÷", keyType: .op) {
                    print("÷")
                }
            }
            
            GridRow {
                createKeyButton(label: "7", keyType: .number) {
                    print("7")
                }
                
                createKeyButton(label: "8", keyType: .number) {
                    print("8")
                }
                
                createKeyButton(label: "9", keyType: .number) {
                    print("8")
                }
                
                createKeyButton(label: "×", keyType: .op) {
                    print("×")
                }
            }
            
            GridRow {
                createKeyButton(label: "4", keyType: .number) {
                    print("4")
                }
                
                createKeyButton(label: "5", keyType: .number) {
                    print("5")
                }
                
                createKeyButton(label: "6", keyType: .number) {
                    print("6")
                }
                
                createKeyButton(label: "-", keyType: .op) {
                    print("-")
                }
            }
            
            GridRow {
                createKeyButton(label: "1", keyType: .number) {
                    print("1")
                }
                
                createKeyButton(label: "2", keyType: .number) {
                    print("2")
                }
                
                createKeyButton(label: "3", keyType: .number) {
                    print("3")
                }
                
                createKeyButton(label: "+", keyType: .op) {
                    print("+")
                }
            }
            
            GridRow {
                createKeyButton(systemImageName: "ellipsis", keyType: .number) {
                    print("menu")
                }
                
                createKeyButton(label: "0", keyType: .number) {
                    print("0")
                }
                
                createKeyButton(label: ".", keyType: .number) {
                    print(".")
                }
                
                createKeyButton(label: "=", keyType: .op) {
                    print("=")
                }
            }
        }
    }
    
    private func createKeyButton(label: String, keyType: KeyType, didTap: @escaping () -> Void) -> some View {
        return createKeyButton(
            Text(label)
                .font(.largeTitle),
            keyType: keyType,
            didTap: didTap
        )
    }
    
    private func createKeyButton(systemImageName: String, keyType: KeyType, didTap: @escaping () -> Void) -> some View {
        return createKeyButton(
            Image(systemName: systemImageName)
                .resizable()
                .scaledToFit()
                .padding(28),
            keyType: keyType,
            didTap: didTap
        )
    }
    
    private func createKeyButton(_ titleView: some View, keyType: KeyType, didTap: @escaping () -> Void) -> some View {
        let color: Color

        switch keyType {
        case .op:
            color = .orange
        case .number:
            color = .gray
        case .control:
            color = Color(UIColor.lightGray)
        }
        
        return GeometryReader { geometry in
            Button {
                didTap()
            } label: {
                ZStack {
                    titleView
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundStyle(.white)
                        .background(color)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private enum KeyType {
        case op
        case number
        case control
    }
}

#Preview {
    KeyPadView()
}
