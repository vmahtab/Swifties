//
//  homepageSearch.swift
//  wanderhub
//
//  Created by Neha Pinnu on 3/24/24.
//
// TODO: FIXME this search bar might be useful later
import UIKit

class SearchBar: UIViewController, UISearchBarDelegate {
    let searchBar = UISearchBar()
    //    let currentTrip = UIButton()
    //    let exploreNearby = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearch()
        //        setupButtons()
    }
    
    func setupSearch () {
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        searchBar.barTintColor = UIColor(backCol)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        searchBar.placeholder = "Where do you want to go?"
    }
    
    //    func setupButtons() {
    //        currentTrip.translatesAutoresizingMaskIntoConstraints = false
    //        currentTrip.setTitle("Go to current trip", for: .normal)
    //        currentTrip.backgroundColor = UIColor.systemYellow
    //        currentTrip.setTitleColor(UIColor.white, for: .normal)
    //        currentTrip.layer.cornerRadius = 10
    //        view.addSubview(currentTrip)
    //
    //        exploreNearby.translatesAutoresizingMaskIntoConstraints = false
    //        exploreNearby.setTitle("Explore nearby", for: .normal)
    //        exploreNearby.backgroundColor = UIColor.systemYellow
    //        exploreNearby.setTitleColor(UIColor.white, for: .normal)
    //        exploreNearby.layer.cornerRadius = 10
    //        view.addSubview(exploreNearby)
    //
    //        let buttonHeight: CGFloat = 50
    //        let buttonSpacing: CGFloat = 16
    //
    //        NSLayoutConstraint.activate([
    //            currentTrip.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
    //            currentTrip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    //            currentTrip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    //            currentTrip.heightAnchor.constraint(equalToConstant: buttonHeight),
    //
    //            exploreNearby.topAnchor.constraint(equalTo: currentTrip.bottomAnchor, constant: buttonSpacing),
    //            exploreNearby.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    //            exploreNearby.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    //            exploreNearby.heightAnchor.constraint(equalToConstant: buttonHeight)
    //        ])
    //    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            print("Searching for \(searchText)")
        }
    }
}
