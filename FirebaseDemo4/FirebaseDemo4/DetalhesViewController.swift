//
//  DetalhesViewController.swift
//  FirebaseDemo4
//
//  Created by Petrus Souza on 20/09/20.
//  Copyright © 2020 Petrus Souza. All rights reserved.
//

import UIKit

class DetalhesViewController: UIViewController {

    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var lbSobrenome: UILabel!
    @IBOutlet weak var lbNomeCompleto: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            let user = SharedPreferences.getLastUser()
            self.preencheDados(user: user)
        }
    }
    private func preencheDados(user: User?){
        if user != nil {
            lbNome.text = user?.givenName ?? ""
            lbSobrenome.text = user?.familyName ?? ""
            lbNomeCompleto.text = user?.fullName ?? ""
            lbEmail.text = user?.email ?? ""
        }
    }
    
    @IBAction func fechar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
