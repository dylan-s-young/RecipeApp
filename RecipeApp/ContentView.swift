//
//  ContentView.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
//    @StateObject private var userViewModel = UserViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(recipeViewModel)
                .tabItem {
                    Label("", systemImage: "fork.knife.circle")
                }
            
            FavoriteView()
                .tabItem {
                    Label("", systemImage: "heart.circle")
                }
            
            ProfileView()
                .tabItem {
                    Label("", systemImage: "person.crop.circle.fill")
                }
            
        }
        .task {
            await recipeViewModel.fetchRandomMeals()
        }
    }
}

#Preview {
    ContentView()
}
