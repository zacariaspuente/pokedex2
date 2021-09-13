//
//  PokeCell.swift
//  PokedexApp
//
//  Created by Zacarias on 08/09/2021.
//  Copyright © 2021 Zacarias. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    
        @IBOutlet weak var thumbImg: UIImageView!
        @IBOutlet weak var nameLbl: UILabel!
        
        var pokemon: Pokemon!
    
    //redondear la celda del pokemon
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    //conf de pokemon en la celda NOMBRE E IMAGEN
        
        func configureCell(pokemon: Pokemon) {
            self.pokemon = pokemon
            
            nameLbl.text = self.pokemon.name.capitalized
            thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        }
}
