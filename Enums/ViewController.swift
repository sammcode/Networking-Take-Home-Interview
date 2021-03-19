//
//  ViewController.swift
//  Enums
//
//  Created by Fernando Olivares on 10/26/20.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var loading: UIActivityIndicatorView!
	@IBOutlet var personNameLabel: UILabel!

    let networkController = NetworkController(baseURL: URL(string: "https://swapi.dev/api/people/1")!)

	override func viewDidLoad() {
		super.viewDidLoad()
        getNetworkPerson()
	}

    func getNetworkPerson() {

        DispatchQueue.main.async {
            self.loading.startAnimating()
        }

        networkController.fetch { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.loading.stopAnimating()
                self.loading.isHidden = true
            }

            switch result {
            case .success(let person):
                DispatchQueue.main.async {
                    self.personNameLabel.text = person.name
                }
            case .failure(let error):
                let alert = UIAlertController(title: "There was an error.", message: error.errorDescription, preferredStyle: .alert)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }


        }
    }
}

