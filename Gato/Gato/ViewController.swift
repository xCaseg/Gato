//
//  ViewController.swift
//  Gato
//
//  Created by Usuario on 12/10/24.
//
import UIKit
import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JugarAJuego" { 
            let juegoVC = segue.destination as! JuegoUIViewController
            juegoVC.mostrarAlerta = true
        }
    }

    @IBAction func btnJugar(_ sender: UIButton) {
        performSegue(withIdentifier: "JugarAJuego", sender: self)
    }
}
