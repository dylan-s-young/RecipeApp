//
//  FavoriteView.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//

import SwiftUI

struct FavoriteView: View {
    @AppStorage("favoriteIds") private var favoriteIdsString: String = ""

    private var favoriteIds: [String] {
        favoriteIdsString
            .components(separatedBy: ",")
    }
    
    var body: some View {
        VStack {
            List(favoriteIds, id: \.self) { id in
                Text("FavoriteIds: \(id)")
            }
        }
    }
}

#Preview {
    FavoriteView()
}


