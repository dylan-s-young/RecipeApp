import SwiftUI

struct HomeView: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    @AppStorage("favoriteIds") private var favoriteIdsString: String = ""

    private var favoriteIds: [String] {
        get {
            favoriteIdsString.components(separatedBy: ",").filter { !$0.isEmpty }
        }
        set {
            favoriteIdsString = newValue.joined(separator: ",")
        }
    }
    
    var body: some View {
        if recipeViewModel.isLoading {
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            if let currentMeal = recipeViewModel.currentMeal {
                RecipeContentView(
                    meal: currentMeal,
                    favoriteIds: favoriteIds,
                    onDismiss: {
                        // Go to next meal (dislike/pass)
                        recipeViewModel.loadNextMeal()
                    },
                    onFavorite: { meal in
                        // Like the meal and go to next
                        addToFavorites(meal)
                        recipeViewModel.loadNextMeal()
                    }
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .animation(.easeInOut(duration: 0.5), value: recipeViewModel.currentMeal?.id)
            } else {
                EmptyStateView()
            }
        }
    }
    
    private func addToFavorites(_ meal: Meal) {
        let currentFavorites = favoriteIds
        
        // Only add if not already favorited
        if !currentFavorites.contains(meal.id) {
            let newFavorites = currentFavorites + [meal.id]
            favoriteIdsString = newFavorites.joined(separator: ",")
        }
    }
}

// Separate view for the recipe content - cleaner and more testable
struct RecipeContentView: View {
    let meal: Meal
    let favoriteIds: [String]
    let onDismiss: () -> Void
    let onFavorite: (Meal) -> Void
    
    private var isFavorited: Bool {
        favoriteIds.contains(meal.id)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    // No more nil coalescing needed!
                    Text(meal.name)
                        .font(Font.customOpenSans(openSansType: .bold, size: 22, textStyle: .title))
                    if let mealArea = meal.area {
                        Text(mealArea)
                            .font(Font.customOpenSans(openSansType: .medium, size: 18, textStyle: .title))
                            .padding(.top, -12)
                    }
                    
                    RecipeImageView(thumbnailURL: meal.thumbnail)
                    
                    if let youtubeURL = meal.youtube {
                        VideoButtonView(youtubeURL: youtubeURL)
                    }
                    
                    Divider()
                    
                    IngredientsView(ingredients: meal.ingredients)
                    
                    if let instructions = meal.instructions {
                        InstructionsView(instructions: instructions)
                    }
                    
                    Spacer()
                        .frame(height: 70)
                }
            }
            
            ActionButtonsView(
                isFavorited: isFavorited,
                onDismiss: onDismiss,
                onFavorite: { onFavorite(meal) }
            )
        }
        .padding(.horizontal, 16)
    }
}

// Break down into smaller, focused views
struct RecipeImageView: View {
    let thumbnailURL: String?
    
    var body: some View {
        AsyncImage(url: URL(string: thumbnailURL ?? "")) { phase in
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
    }
}

struct VideoButtonView: View {
    let youtubeURL: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: youtubeURL) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "play.fill")
                    .foregroundColor(Color.black)
                
                Text("Watch Video")
                    .foregroundColor(Color.black)
                    .font(Font.customOpenSans(openSansType: .medium, size: 18, textStyle: .title))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
}

struct IngredientsView: View {
    let ingredients: [Ingredient]
    
    var body: some View {
        Text("Ingredients")
            .font(Font.customOpenSans(openSansType: .bold, size: 18, textStyle: .headline))
        
        ForEach(ingredients) { ingredient in
            VStack {
                HStack {
                    Text(ingredient.name)
                        .font(Font.customOpenSans(openSansType: .medium, size: 16, textStyle: .caption))
                    
                    Spacer()
                    
                    Text(ingredient.measure)
                        .font(Font.customOpenSans(openSansType: .medium, size: 16, textStyle: .headline))
                }
                Divider()
            }
        }
    }
}

struct InstructionsView: View {
    let instructions: String
    
    var body: some View {
        Text("Instructions")
            .font(Font.customOpenSans(openSansType: .bold, size: 18, textStyle: .headline))
        
        Text(instructions)
            .font(Font.customOpenSans(openSansType: .medium, size: 16, textStyle: .headline))
    }
}

struct ActionButtonsView: View {
    let isFavorited: Bool
    let onDismiss: () -> Void
    let onFavorite: () -> Void
    
    var body: some View {
        HStack {
            CircularButtonView(
                image: "xmark",
                action: onDismiss
            )
            
            Spacer()
            
            CircularButtonView(
                image: "heart",
                action: onFavorite
            )
        }
        .padding(.bottom, 16)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No recipes available")
                .font(Font.customOpenSans(openSansType: .medium, size: 18, textStyle: .headline))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(RecipeViewModel())
}
