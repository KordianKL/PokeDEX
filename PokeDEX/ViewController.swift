//
//  ViewController.swift
//  PokeDEX
//
//  Created by Kordian Ledzion on 24.05.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,  UISearchBarDelegate {
    
    @IBOutlet weak var pokemonsNameUILabel: UILabel!
    @IBOutlet weak var pokemonsUIImageView: UIImageView!
    @IBOutlet weak var pokemonsSearchBar: UISearchBar!
    @IBOutlet weak var pokemonsUITableView: UITableView!
    var pokemonsList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 7.0
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        pokemonsUITableView.delegate = self
        pokemonsUITableView.dataSource = self
        pokemonsSearchBar.delegate = self
        API.request(.getAllPokemons, completion: { completionStatus, valueDictionary in
            if(completionStatus) {
                let pokemons = (valueDictionary!["results"] as? [[String: Any]])!
                pokemons.forEach { pokemon in
                    print(pokemon["name"]!)
                    self.pokemonsList.append(pokemon)
                }
            }
            self.pokemonsUITableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let pokemon = pokemonsList[indexPath.row]
        cell.textLabel?.text = pokemon["name"] as? String
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonsList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokemonsUIImageView.image = UIImage(named: "\(indexPath.row + 1)")
        pokemonsNameUILabel.text = ((pokemonsList[indexPath.row])["name"] as? String)!
    }
}
