//
//  JuegoUIViewController.swift
//  Gato
//
//  Created by Usuario on 12/10/24.
//

import UIKit

class JuegoUIViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //-------------------------------------------------------------- INTERFAZ DEL JUEGO --------------------------------------------------------------//
    
    @IBOutlet weak var Tablero: UICollectionView!
    @IBOutlet weak var LblGato: UILabel!
    @IBOutlet weak var LblRobot: UILabel!
    @IBOutlet weak var emojiGato: UILabel!
    @IBOutlet weak var emojiRobot: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10 // Espacio horizontal entre columnas
        layout.minimumLineSpacing = 10 // Espacio vertical entre filas
        
        let anchoCelda = (Tablero.frame.size.width - 20) / 3 // Resta 20 (10 para cada lado)
        layout.itemSize = CGSize(width: anchoCelda, height: anchoCelda) // Celdas cuadradas
        
        Tablero.collectionViewLayout = layout
        Tablero.dataSource = self
        Tablero.delegate = self
        iniciarJuego()
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "Celda", for: indexPath) as! CeldaEtiqueta
        
        celda.layer.cornerRadius = celda.frame.size.width / 2
        celda.clipsToBounds = true

        if almacenJugadas.count > indexPath.row {
            switch almacenJugadas[indexPath.row] {
            case .🐱:
                celda.CeldaLabel.text = "🐱"
                celda.CeldaLabel.textColor = .systemRed
            case .🤖:
                celda.CeldaLabel.text = "🤖"
                celda.CeldaLabel.textColor = .systemPink
            default:
                celda.CeldaLabel.text = ""
            }
        } else {
            celda.CeldaLabel.text = ""
        }
        
        return celda
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mostrarAlerta {
            elegirTurno() // Muestra la alerta una vez que la vista ha aparecido
        }
    }



    
    //-------------------------------------------------------------- LOGICA --------------------------------------------------------------//
    @IBOutlet weak var InfoLbl: UILabel!
    
    var juegoActivo: Bool = true
    var turno: tipoJugador?
    var jugadorGanador: tipoJugador?
    var almacenJugadas: [tipoJugada] = Array(repeating: .none, count: 9)
    var mostrarAlerta: Bool = false
    
    enum tipoJugada {
        case 🐱, 🤖, none
    }

    enum tipoJugador {
        case gato, robot, none
    }

    let combinacionesGanadoras = [
        (0, 1, 2),
        (3, 4, 5),
        (6, 7, 8),
        (0, 4, 8),
        (2, 4, 6),
        (0, 3, 6),
        (1, 4, 7),
        (2, 5, 8)
    ]

    func elegirTurno() {

        let mensaje = UIAlertController(title: "Elegir Turno",
                                             message: "¿Quieres jugar primero o después?",
                                             preferredStyle: .alert)

        let primero = UIAlertAction(title: "Primero", style: .default) { _ in
            self.turno = .gato
            self.robotJuegaPrimero = false // El gato juega primero
            self.mostrarAlerta = false
            self.iniciarJuego()
        }

        let segundo = UIAlertAction(title: "Segundo", style: .default) { _ in
            self.turno = .robot
            self.robotJuegaPrimero = true // El robot juega segundo
            self.mostrarAlerta = false
            self.iniciarJuego()
            self.realizarJugadaRobot()
        }

            mensaje.addAction(primero)
            mensaje.addAction(segundo)

            present(mensaje, animated: true)
    }
    
    func iniciarJuego() {
        juegoActivo = true
        jugadorGanador = nil
        almacenJugadas = Array(repeating: .none, count: 9)
        turno = tipoJugador.none
        
        // Reinicia las celdas
        for index in 0..<almacenJugadas.count {
            almacenJugadas[index] = .none
            if let cell = Tablero.cellForItem(at: IndexPath(item: index, section: 0)) as? CeldaEtiqueta {
                cell.CeldaLabel.text = ""
            }
        }
    }

    
    @IBAction func ResetearJuego(_ sender: Any) {
        emojiGato.text = "🐱"
        LblGato.text = "Prr..."
        emojiRobot.text = "🤖"
        LblRobot.text = "¡Listo!"
        iniciarJuego()
        mostrarAlerta = true
        elegirTurno()
    }


    func realizarJugada(jugada: Int) {
        guard juegoActivo, almacenJugadas[jugada] == .none else { return }
        
        // Guardar la jugada del jugador
        almacenJugadas[jugada] = .🐱
        verificarGanador()

        if juegoActivo {
            turno = .robot
            realizarJugadaRobot()
        }
    }

    func realizarJugadaRobot() {
        // Primero, intenta ganar
        if let jugadaGanadora = obtenerJugadaGanadora(tipo: .robot).0 {
            // Si hay una jugada ganadora, realiza esa jugada
            almacenJugadas[jugadaGanadora] = .🤖
            Tablero.reloadItems(at: [IndexPath(item: jugadaGanadora, section: 0)])
            LblRobot.text = ("Jugando para ganar:  \(jugadaGanadora)")

        } else {
            // Si no hay jugada ganadora, intenta bloquear al gato
            if let jugadaBloqueo = obtenerJugadaGanadora(tipo: .gato).0 {
                almacenJugadas[jugadaBloqueo] = .🤖
                Tablero.reloadItems(at: [IndexPath(item: jugadaBloqueo, section: 0)])
                LblRobot.text = ("Bloqueando Jugada: \(jugadaBloqueo)")
            } else {
                // Si no hay ni jugada ganadora ni bloqueo, elige la mejor jugada aleatoria
                if let mejorJugada = obtenerMejorJugadaAleatoria() {
                    almacenJugadas[mejorJugada] = .🤖
                    Tablero.reloadItems(at: [IndexPath(item: mejorJugada, section: 0)])
                    LblRobot.text = ("Muevo aleatorio: \(mejorJugada + 1)")
                }
            }
        }
        
        verificarGanador()
        if juegoActivo {
            turno = .gato
        }
    }
    
    var robotJuegaPrimero: Bool = false

    func obtenerMejorJugadaAleatoria() -> Int? {
        var esquinas = [0, 2, 6, 8] // Definición de las esquinas
        let centro = 4
        
        if robotJuegaPrimero {
            
            esquinas.shuffle()

            // Verificar si alguna esquina está disponible
            for esquina in esquinas {
                if almacenJugadas[esquina] == .none {
                    LblRobot.text = ("Elijo la esquina: \(esquina)")
                    return esquina
                }
            }
            
            // Si no hay esquinas disponibles, elige el centro
            if almacenJugadas[centro] == .none {
                LblRobot.text = "Elijo el centro"
                return centro
            }
        } else {
            // Si el robot juega segundo, verifica el centro primero
            if almacenJugadas[centro] == .none {
                LblRobot.text = "Elijo el centro"
                return centro
            }
            
            // Mezcla las esquinas
            esquinas.shuffle()

            // Luego verifica si alguna esquina está disponible
            for esquina in esquinas {
                if almacenJugadas[esquina] == .none {
                    LblRobot.text = ("Elijo la esquina: \(esquina)")
                    return esquina
                }
            }
        }
        
        // Finalmente, si no hay esquinas o centro, elige aleatoriamente
        return obtenerJugadaAleatoria()
    }


    func obtenerJugadaGanadora(tipo: tipoJugador) -> (Int?, String) {
        for combinacion in combinacionesGanadoras {
            let (a, b, c) = combinacion
            let jugadaActual = almacenJugadas
            
            // Identificar el símbolo del jugador actual
            let simboloBuscado: tipoJugada = tipo == .gato ? .🐱 : .🤖
            
            // Contar cuántas jugadas están ocupadas por el símbolo buscado
            var contador = 0
            var posicionLibre: Int? = nil

            // Contar las jugadas ocupadas y buscar la posición libre
            for (index, jugada) in [jugadaActual[a], jugadaActual[b], jugadaActual[c]].enumerated() {
                if jugada == simboloBuscado {
                    contador += 1
                } else if jugada == .none {
                    // Guardar la posición libre
                    posicionLibre = [a, b, c][index]
                }
            }

            // Verificar si hay exactamente 2 jugadas ocupadas y una libre
            if contador == 2, let libre = posicionLibre {
                return (libre, "alto") // Alto riesgo si la próxima jugada puede dar la victoria
            }
        }
        return (nil, "bajo") // Riesgo bajo si no hay jugada ganadora
    }

    func obtenerJugadaAleatoria() -> Int {
        var posicionesDisponibles: [Int] = []

        for i in 0..<almacenJugadas.count {
            if almacenJugadas[i] == .none {
                posicionesDisponibles.append(i)
            }
        }

        if !posicionesDisponibles.isEmpty {
            let indiceAleatorio = Int.random(in: 0..<posicionesDisponibles.count)
            return posicionesDisponibles[indiceAleatorio]
        }

        return -1
    }

    func verificarGanador() {
        for combinacion in combinacionesGanadoras {
            let (a, b, c) = combinacion
            if almacenJugadas[a] != .none && almacenJugadas[a] == almacenJugadas[b] && almacenJugadas[b] == almacenJugadas[c] {
                juegoActivo = false
                
                // Verificar el símbolo del ganador
                if almacenJugadas[a] == .🐱 {
                    jugadorGanador = .gato // El gato gana
                } else if almacenJugadas[a] == .🤖 {
                    jugadorGanador = .robot // La máquina gana
                }
                
                juegoGanado()
                return
            }
        }

        if !almacenJugadas.contains(.none) {
            juegoActivo = false
            InfoLbl.text = "¡Empate!"
            LblGato.text = "Grrr..."
            LblRobot.text = "Bi-Bo-Bip"
            emojiGato.text = "😾"
            emojiRobot.text = "👽"
        }
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if juegoActivo && almacenJugadas[indexPath.row] == .none {
            almacenJugadas[indexPath.row] = .🐱
            collectionView.reloadItems(at: [indexPath])
            InfoLbl.text = ("Celda seleccionada: \(indexPath.row + 1)")
            verificarGanador()

            if juegoActivo {
                turno = .robot
                realizarJugadaRobot()
            }
        }
    }

    func juegoGanado() {
        juegoActivo = false
        
        if  jugadorGanador == .robot {
            InfoLbl.text = "¡Ganó el robot!"
            LblRobot.text = "HA-HA-HA!"
            emojiGato.text = "😿"
            LblGato.text = "purr.. purr.."
            emojiRobot.text = "🦾"
        } else {
            InfoLbl.text = "¡Ganó el gato!"
            LblGato.text = "His-His-His!"
            LblRobot.text = "#$!%#"
            emojiGato.text = "😹"
            emojiRobot.text = "👾"
            
        }
    }


}


