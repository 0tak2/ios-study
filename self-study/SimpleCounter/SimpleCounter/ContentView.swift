//
//  ContentView.swift
//  SimpleCounter
//
//  Created by 임영택 on 4/26/25.
//

import SwiftUI

struct ContentView: View {
    @State var count = 0 {
        didSet {
            print("b. count did set: \(count)")
        }
    }
    
    init() {
        print("a. ContentView init")
    }
    
    var body: some View {
        print("c. body computed. \(count)\n")
        
        return VStack {
            Text("\(count)")
                .font(.largeTitle)
            
            HStack {
                Button {
                    count -= 1
                } label: {
                    Image(systemName: "minus")
                }
                
                Button {
                    count += 1
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
