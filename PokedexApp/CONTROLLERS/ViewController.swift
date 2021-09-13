//
//  ViewController.swift
//  PokedexApp
//
//  Created by Zacarias on 08/09/2021.
//  Copyright © 2021 Zacarias. All rights reserved.
//

import UIKit
import AVFoundation //para agregar musica

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {     // googlear que hace cada protocolo
    
    var pokemon = [Pokemon]()        //array de ttodos los pokemones
    var filteredPokemon = [Pokemon]()   //array de pokemones para la barra de buscar
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false            //comprueba si estamos en este array verdad o false
    
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchbar.delegate = self
        
        searchbar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
 
        
      }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1    //va a sonar constantemente
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
        
    func parsePokemonCSV(){                 //PARSING CSV DATA (csv.swift
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows{                    //FOR LOOP PARA PASAR POR TODOS LOS POKEMONES
                let pokeId = Int(row["id"]!)!   // ACA OBTENEMOS NOMBRE Y ID
               let name = row["identifier"]!
                
            let poke = Pokemon(name: name, pokedexId: pokeId)   //POKEMON OBJECT
               pokemon.append(poke)                  //obtiene la data y la pasa al array (pokemon)
            }
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    
    
    //aca creamos las celdas
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
             
                                             //aca llamamos a todos los pokemones
            let poke: Pokemon!
            if inSearchMode {          //si estamos en search bar filtrame los pokemon
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
            } else {                  //sino tirame toda la lista completa
                poke = pokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
            }
           
            return cell
        } else {
            return UICollectionViewCell()    //dequeue recicla las celdas para q la app no sea heavy
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    //numero de items
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if inSearchMode {
        return filteredPokemon.count
    }
        return pokemon.count
    }
    
    // numero de las secciones
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //define el tamaño de la celda
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2      //si lo apretas el logo se vuelve mas teransparente
        } else{
            musicPlayer.play()
            sender.alpha = 1.0     //vuelve al color original
        }
    }
        func searchBarSearchButtonClicked(searchbar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchbar.text == nil || searchbar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            
            let lower = searchbar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})   //filtracion de pokemon
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let DetailsVC = segue.destination as? PokemonDetailVC{
                if let poke = sender as? Pokemon {
                    DetailsVC.pokemon = poke
                    
                }
            }
        }
    }

}


