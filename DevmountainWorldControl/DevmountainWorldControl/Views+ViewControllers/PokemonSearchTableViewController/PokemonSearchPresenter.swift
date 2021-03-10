//
//  PokemonSearchPresenter.swift
//  DevmountainWorldControl
//
//  Created by Jayden Garrick on 3/10/21.
//

import UIKit

protocol PokemonSearchView {
    func reload()
}

fileprivate typealias Constants = PokemonSearchTableViewController.Constants

class PokemonSearchPresenter {
    // MARK: - Properties
    
    // Dependencies
    let view: PokemonSearchView
    let networkManager = PokemonNetworkingManager()
    
    // SOT
    var pokemon: [Pokemon] = []
    
    // Helpers
    var numberOfRows: Int {
        return pokemon.count
    }
    let cellHeight: CGFloat = 490
        
    // MARK: - Initialization
    init(_ view: PokemonSearchView) {
        self.view = view
    }
    
    // MARK: - TableView Helpers
    func cellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName) as! PokemonCardTableViewCell
        let pokemonForCell = pokemon[indexPath.row]
        cell.pokemon = pokemonForCell
        
        networkManager.fetchPokemonImage(with: pokemonForCell) { (result) in
            switch result {
            case .success(let image):
                cell.setImage(image)
            case .failure(let error):
                print(error)
                cell.setImage(UIImage(systemName: "photo.fill")!)
            }
        }
        return cell
    }
    
    // Actions
    func searchPokemon(_ searchTerm: String) {
        networkManager.fetchPokemon(with: searchTerm) { [weak self] (result) in
            switch result {
            case .success(let fetchedPokemon):
                self?.pokemon = fetchedPokemon
            case .failure(let error):
                print(error)
                self?.pokemon.removeAll()
            }
            self?.view.reload()
        }
    }
            
}
