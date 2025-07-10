//
//  HomeView.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(recipeViewModel.currentMeal?.name ?? "")
                        .font(Font.customOpenSans(openSansType: .bold, size: 22, textStyle: .title))
                        .padding(.horizontal, 16)
                    
                    AsyncImage(url: URL(string: recipeViewModel.currentMeal?.thumbnail ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .clipped()
                                .cornerRadius(7)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 16)

                    Text("Ingredients")
                        .font(Font.customOpenSans(openSansType: .bold, size: 18, textStyle: .headline))
                        .padding(.horizontal, 16)
                }
                
            }
            
            Spacer ()
            
            HStack {
                CircularButtonView(image: "xmark", action: {
                    print("Hi")
                })
                
                Spacer()
                
                CircularButtonView(image: "heart.fill", action: {
                    print("bye")
                })
            }
            .padding(16)
            
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(RecipeViewModel())
}
