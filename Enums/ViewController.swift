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

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let networkController = NetworkController()
		networkController.fetch { (_, _) in
			
			
			
		}
	}


}

