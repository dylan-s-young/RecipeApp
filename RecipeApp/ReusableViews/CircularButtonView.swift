//
//  CircularButtonView.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//

import SwiftUI


struct CircularButtonView: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                    .shadow(radius: 6)
                
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CircularButtonView(image: "heart.fill", action: {
        print("Button tapped")
    })
}
