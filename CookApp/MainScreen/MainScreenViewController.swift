
import UIKit
import Kingfisher


protocol MainScreenViewProtocol: AnyObject {
    func reloadData()
    func showDetailScreen(with presenter: DetailPresenterProtocol)
    func updateRecipes(_ recipes: [Recipe])
}

// MARK: - MainScreenViewController
final class MainScreenViewController: UIViewController, MainScreenViewProtocol {
    var presenter: MainScreenPresenter!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let recipeSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search recipe"
        searchBar.barTintColor = .white
        searchBar.tintColor = .black
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: - Initializers
    
    init(presenter: MainScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.fetchData()
        recipeSearchBar.delegate = self
        
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(recipeSearchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            recipeSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recipeSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipeSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: recipeSearchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.identifier)
    }
    
    // MARK: - MainScreenViewProtocol
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showDetailScreen(with presenter: DetailPresenterProtocol) {
        let detailViewController = DetailViewController()
        detailViewController.presenter = presenter
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func updateRecipes(_ recipes: [Recipe]) {
        presenter.recipes = recipes
        reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as! RecipeTableViewCell
        let recipe = presenter.recipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = presenter.recipes[indexPath.row]
        let detailViewController = DetailViewController()
        let presenter = DetailPresenter(recipe: recipe)
        detailViewController.presenter = presenter
        presenter.view = detailViewController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MainScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter.fetchData()
        } else {
            presenter.searchRecipes(with: searchText)
        }
    }
}
