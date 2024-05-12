import Foundation

struct Response: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable  {
    let recipe: Recipe
}

struct Recipe: Decodable  {
    let label: String
    let image: URL
    let calories: Double
    let ingredients: [Ingredient]
}

struct Ingredient: Decodable  {
    let text: String
}



