
import UIKit

// MARK: - DetailPresenterProtocol

protocol DetailPresenterProtocol {
    func presentRecipe()
}

// MARK: - DetailPresenter

final class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewProtocol?
    var recipe: Recipe?
    
    init(recipe: Recipe?) {
        self.recipe = recipe
    }
    
    func presentRecipe() {
        guard let recipe = recipe else { return }
        view?.displayRecipe(recipe)
    }
}
