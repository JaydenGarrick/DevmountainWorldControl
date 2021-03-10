//
//  PokemonCardTableViewCell.swift
//  DevmountainWorldControl
//
//  Created by Jayden Garrick on 3/10/21.
//

import UIKit

class PokemonCardTableViewCell: UITableViewCell {
    //  MARK: - Properties
    
    // UI
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
        
    // SOT
    var pokemon: Pokemon! {
        didSet {
            setupCell()
        }
    }

    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
            
    private func setupCell() {
        nameLabel.text = "\(pokemon.name) \(pokemon.hp ?? "No HP")hp"
        rarityLabel.text = pokemon.rarity
        setLabel.text = pokemon.set
    }
    
    func setImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.pokemonImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        self.pokemonImageView.image = nil
    }

}
