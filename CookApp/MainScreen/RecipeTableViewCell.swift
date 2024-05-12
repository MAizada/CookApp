
import UIKit
import Kingfisher

protocol RecipeTableViewCellDelegate: AnyObject {
    func didTapSaveButton(on cell: RecipeTableViewCell, for recipe: Recipe)
}

// MARK: - RecipeTableViewCell
final class RecipeTableViewCell: UITableViewCell {
    static let identifier = "RecipeCell"
    
    var recipe: Recipe?
    weak var delegate: RecipeTableViewCellDelegate?
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(recipeImageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            recipeImageView.widthAnchor.constraint(equalToConstant: 75),
            recipeImageView.heightAnchor.constraint(equalToConstant: 75),
            
            nameLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.label
        recipeImageView.kf.setImage(with: recipe.image)
    }
}
