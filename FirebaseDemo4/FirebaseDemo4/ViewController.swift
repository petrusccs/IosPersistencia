//
//  ViewController.swift
//  FirebaseDemo4
//
//  Created by Petrus Souza on 17/09/20.
//  Copyright © 2020 Petrus Souza. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var lbNome: UILabel!
    @IBOutlet weak var svUltimoUsuario: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            let user = SharedPreferences.getLastUser()
            self.svUltimoUsuario.isHidden = (user == nil)
            self.lbNome.text = user?.fullName ?? user?.givenName ?? ""
        }
        /*if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
        print("logado")
        }
        else
        {
         print("nao Logado")
        }*/
    }


}

