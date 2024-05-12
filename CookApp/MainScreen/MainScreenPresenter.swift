
import UIKit
import Kingfisher


protocol MainScreenPresenterProtocol {
    func fetchData()
    func showDetail(for recipe: Recipe)
    func searchRecipes(with query: String)
}

// MARK: - MainScreenPresenter
final class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var view: MainScreenViewProtocol?
    var recipes: [Recipe] = []
    
    init() {}
    
    func fetchData() {
        let urlString = "https://api.edamam.com/api/recipes/v2?type=public&q=chicken,fish,beef&app_id=a7340a07&app_key=6900c47c7774ba2dd1a5f71c4364ca51"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("en", forHTTPHeaderField: "Accept-Language")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP status code \(httpResponse.statusCode)")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let recipeData = try decoder.decode(Response.self, from: data)
                    self.recipes = recipeData.hits.map { hit in
                        return Recipe(label: hit.recipe.label, image: hit.recipe.image, calories: hit.recipe.calories, ingredients: hit.recipe.ingredients)
                    }
                    
                    DispatchQueue.main.async {
                        self.view?.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else {
                print("No data received")
            }
        }.resume()
    }
    
    func showDetail(for recipe: Recipe) {
        let detailPresenter = DetailPresenter(recipe: recipe)
        view?.showDetailScreen(with: detailPresenter)
    }
    
    func searchRecipes(with query: String) {
        let filteredRecipes = recipes.filter { $0.label.lowercased().contains(query.lowercased()) }
        view?.updateRecipes(filteredRecipes)
    }
}
