//
//  PokemonSearchTableViewController.swift
//  DevmountainWorldControl
//
//  Created by Jayden Garrick on 3/10/21.
//

import UIKit

class PokemonSearchTableViewController: UITableViewController {
    
    // MARK: - Properties
    var presenter: PokemonSearchPresenter!
    
    // MARK: - Constants
    enum Constants {
        static let cellName = "PokemonCardTableViewCell"
    }

    // MARK: - ViewLifecycle / Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        // Search Controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemon"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
        // Cell
        tableView.register(UINib(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellName)
        
        // Presenter
        presenter = PokemonSearchPresenter(self)
    }
    
}


// MARK: - DataSource
extension PokemonSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.cellForRowAt(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.cellHeight
    }

}

// MARK: - PokemonSearchView
extension PokemonSearchTableViewController: PokemonSearchView {
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - SerachBarDelegate
extension PokemonSearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchPokemon(searchBar.text ?? "")
    }
}
