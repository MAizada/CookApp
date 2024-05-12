// MARK: - DetailViewProtocol

import UIKit
import Kingfisher

protocol DetailViewProtocol: AnyObject {
    func displayRecipe(_ recipe: Recipe)
}

// MARK: - DetailViewController

final class DetailViewController: UIViewController, DetailViewProtocol {
    
    var presenter: DetailPresenterProtocol?
    
    private let recipeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ingredientsTextTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let caloriesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.presentRecipe()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Recipe Details"
        
        view.addSubview(recipeLabel)
        view.addSubview(recipeImageView)
        view.addSubview(ingredientsTextTextView)
        view.addSubview(caloriesLabel)
        
        let topPadding: CGFloat = 40
        let spacing: CGFloat = 10
        
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            recipeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recipeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            recipeImageView.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: spacing),
            recipeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 240),
            
            ingredientsTextTextView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: spacing),
            ingredientsTextTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ingredientsTextTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ingredientsTextTextView.heightAnchor.constraint(equalToConstant: 240),
            
            caloriesLabel.topAnchor.constraint(equalTo: ingredientsTextTextView.bottomAnchor, constant: spacing),
            caloriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            caloriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            caloriesLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func displayRecipe(_ recipe: Recipe) {
        recipeLabel.text = recipe.label
        
        var ingredientsText = "Ingredients:\n"
        for ingredient in recipe.ingredients {
            ingredientsText += "\(ingredient.text)\n"
        }
        
        ingredientsTextTextView.text = ingredientsText
        caloriesLabel.text = "Calories: \(String(format: "%.2f", recipe.calories))"
        let imageURL = recipe.image
        recipeImageView.kf.setImage(with: imageURL)
    }
}
