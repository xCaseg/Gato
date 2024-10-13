//
//  Logica.swift
//  Gato
//
//  Created by Usuario on 12/10/24.
//

import Foundation
import UIKit

/*
 var objGato:Gato=Gato(jugadorInicial:Gato.TipoJugador.Maquina)


 var tablero=objGato.IniciaJuego()
 PintaTablero()

 while objGato.juegoActivo{

     print("Elije casilla entre 0 a 8:")
     var objValor=readLine()

     if let objValor:String=objValor{
         if let objValorInt:Int=Int(objValor){
             objGato.JugadaHumano(casilla:objValorInt)
             /*
             if objGato.juegoActivo{
                 objGato.JugadaMaquina()
             }
             */1
             PintaTablero()
         }
     }
 }

 print("Juego Terminado")

 if let obj:Gato.TipoJugador=objGato.jugadorGanador{
     print(obj)
     switch obj{
         case Gato.TipoJugador.Humano:
             print("Ganaste")
             break

         case Gato.TipoJugador.Maquina:
             print("Gano la maquina")
             break
         default:
             print("Empate")
             break
     }

 }
 else{
     print("Empate")

 }





 func PintaTablero(){
     var lix=0
     var lsCadena:String=""
     for objTipoJugador in objGato.tablero{

         if lix==0{
             lsCadena=""
         }

         if let obj:Gato.TipoJugador=objTipoJugador{
             switch obj{
                 case Gato.TipoJugador.Humano:
                     lsCadena=lsCadena + "X "
                     break

                 case Gato.TipoJugador.Maquina:
                     lsCadena=lsCadena + "O "
                     break
                 default:
                     lsCadena=lsCadena + "- "
                     break
             }

         }
         else{
             lsCadena=lsCadena + "- "

         }

         lix=lix+1
         if lix>2{
             lix=0
             print(lsCadena)
         }

     }
 }









 class Gato{

     enum TipoJugador{
         case Maquina
         case Humano
     }

     private var jugadorInicial:TipoJugador
     var tablero:Array<TipoJugador?>=[nil,nil,nil,nil,nil,nil,nil,nil,nil]

     var jugadorGanador:TipoJugador?=nil
     var juegoActivo:Bool=false


     private struct jugadaGanadora{
         var primerJugada: Int
         var segundaJugada: Int
         var tercerJugada: Int
         init(){
             self.primerJugada=0
             self.segundaJugada=0
             self.tercerJugada=0
         }
         init(primerJugada:Int,segundaJugada:Int,tercerJugada:Int){
             self.primerJugada=primerJugada
             self.segundaJugada=segundaJugada
             self.tercerJugada=tercerJugada
         }
     }

     private var jugadasGanadoras:Array<jugadaGanadora>=Array<jugadaGanadora>()

     init (jugadorInicial:TipoJugador){
         self.jugadorInicial=jugadorInicial
         self.tablero=[nil,nil,nil,nil,nil,nil,nil,nil,nil]

         var j1=jugadaGanadora(primerJugada:0,segundaJugada:1,tercerJugada:2)
         jugadasGanadoras.append(j1)

         var j2=jugadaGanadora(primerJugada:3,segundaJugada:4,tercerJugada:5)
         jugadasGanadoras.append(j2)

         var j3=jugadaGanadora(primerJugada:6,segundaJugada:7,tercerJugada:8)
         jugadasGanadoras.append(j3)

         var j4=jugadaGanadora(primerJugada:0,segundaJugada:4,tercerJugada:8)
         jugadasGanadoras.append(j4)

         var j5=jugadaGanadora(primerJugada:2,segundaJugada:4,tercerJugada:6)
         jugadasGanadoras.append(j5)

         var j6=jugadaGanadora(primerJugada:0,segundaJugada:3,tercerJugada:6)
         jugadasGanadoras.append(j6)

         var j7=jugadaGanadora(primerJugada:1,segundaJugada:4,tercerJugada:7)
         jugadasGanadoras.append(j7)

         var j8=jugadaGanadora(primerJugada:2,segundaJugada:5,tercerJugada:8)
         jugadasGanadoras.append(j8)

     }


     func IniciaJuego()-> Array<TipoJugador?>{

         if jugadorInicial == TipoJugador.Maquina{
             tablero[Int.random(in: 0...8)]=TipoJugador.Maquina
         }
         juegoActivo=true
         jugadorGanador=nil

         return tablero
     }

     public func JugadaMaquina(){

         var lix=0
         var jugadasHumano:Array<Int>=[0,0,0,0,0,0,0,0,0]
         var jugadasMaquina:Array<Int>=[0,0,0,0,0,0,0,0,0]

         for objTipoJugador in tablero{

           if objTipoJugador==TipoJugador.Humano {

               jugadasHumano[lix]=1
           }
           else if objTipoJugador==TipoJugador.Maquina{
               jugadasMaquina[lix]=1
           }
           lix=lix+1
         }

         //Analiza la jugadas del humano y juega defensivo en caso de riesgo=2

         var riesgo=0

         for jugadaGanadora in jugadasGanadoras{
             riesgo=0

             if tablero[jugadaGanadora.primerJugada] == TipoJugador.Maquina || tablero[jugadaGanadora.segundaJugada] == TipoJugador.Maquina || tablero[jugadaGanadora.tercerJugada] == TipoJugador.Maquina{
                riesgo=0
                //Sin riesgo
             }
             else{
                 if tablero[jugadaGanadora.primerJugada] == TipoJugador.Humano{
                     riesgo=riesgo+1
                 }
                 if tablero[jugadaGanadora.segundaJugada] == TipoJugador.Humano{
                     riesgo=riesgo+1
                 }
                 if tablero[jugadaGanadora.tercerJugada] == TipoJugador.Humano{
                     riesgo=riesgo+1
                 }

                 if riesgo >= 2{
                     if tablero[jugadaGanadora.primerJugada] == nil{
                         tablero[jugadaGanadora.primerJugada] = TipoJugador.Maquina
                         return
                     }
                     if tablero[jugadaGanadora.segundaJugada] == nil{
                         tablero[jugadaGanadora.segundaJugada] = TipoJugador.Maquina
                         return
                     }
                     if tablero[jugadaGanadora.tercerJugada] == nil{
                         tablero[jugadaGanadora.tercerJugada] = TipoJugador.Maquina
                         return
                     }
                 }
             }

         }

         //Analiza la jugadas de maquina y escoge jugada con  probabilidad=2

         var probabilidad=0

         for jugadaGanadora in jugadasGanadoras{
             probabilidad=0

             if tablero[jugadaGanadora.primerJugada] == TipoJugador.Humano || tablero[jugadaGanadora.segundaJugada] == TipoJugador.Humano || tablero[jugadaGanadora.tercerJugada] == TipoJugador.Humano{
                probabilidad=0
                //Sin probabilidad
             }
             else{
                 if tablero[jugadaGanadora.primerJugada] == TipoJugador.Maquina{
                     probabilidad=probabilidad+1
                 }
                 if tablero[jugadaGanadora.segundaJugada] == TipoJugador.Maquina{
                     probabilidad=probabilidad+1
                 }
                 if tablero[jugadaGanadora.tercerJugada] == TipoJugador.Maquina{
                     probabilidad=probabilidad+1
                 }

                 if probabilidad >= 2{
                     if tablero[jugadaGanadora.primerJugada] == nil{
                         tablero[jugadaGanadora.primerJugada] = TipoJugador.Maquina
                         return
                     }
                     if tablero[jugadaGanadora.segundaJugada] == nil{
                         tablero[jugadaGanadora.segundaJugada] = TipoJugador.Maquina
                         return
                     }
                     if tablero[jugadaGanadora.tercerJugada] == nil{
                         tablero[jugadaGanadora.tercerJugada] = TipoJugador.Maquina
                         return
                     }
                 }
             }

         }


         //Analiza la jugadas de maquina y escoge jugada con  probabilidad=1

         for jugadaGanadora in jugadasGanadoras{
             probabilidad=0

             if tablero[jugadaGanadora.primerJugada] == TipoJugador.Humano || tablero[jugadaGanadora.segundaJugada] == TipoJugador.Humano || tablero[jugadaGanadora.tercerJugada] == TipoJugador.Humano{
                probabilidad=0
                //Sin probabilidad
             }
             else{
                 if tablero[jugadaGanadora.primerJugada] == TipoJugador.Maquina{
                     probabilidad=probabilidad+1
                 }
                 if tablero[jugadaGanadora.segundaJugada] == TipoJugador.Maquina{
                     probabilidad=probabilidad+1
                 }
                 if tablero[jugadaGanadora.tercerJugada] == TipoJugador.Maquina{
                     probabilidad=probabilidad+1
                 }

                 if probabilidad == 1{
                     if tablero[jugadaGanadora.primerJugada] == nil{
                         tablero[jugadaGanadora.primerJugada] = TipoJugador.Maquina
                         return
                     }
                     if tablero[jugadaGanadora.segundaJugada] == nil{
                         tablero[jugadaGanadora.segundaJugada] = TipoJugador.Maquina
                         return
                     }
                     if tablero[jugadaGanadora.tercerJugada] == nil{
                         tablero[jugadaGanadora.tercerJugada] = TipoJugador.Maquina
                         return
                     }
                 }
             }

         }


         //Analiza la jugadas de maquina y escoge jugada con  probabilidad=0

         for jugadaGanadora in jugadasGanadoras{
             if tablero[jugadaGanadora.primerJugada] == nil{
                 tablero[jugadaGanadora.primerJugada] = TipoJugador.Maquina
                 return
             }
             if tablero[jugadaGanadora.segundaJugada] == nil{
                 tablero[jugadaGanadora.segundaJugada] = TipoJugador.Maquina
                 return
             }
             if tablero[jugadaGanadora.tercerJugada] == nil{
                 tablero[jugadaGanadora.tercerJugada] = TipoJugador.Maquina
                 return
             }
         }


     }

     func JugadaHumano(casilla:Int)->(Array<TipoJugador?>? , TipoJugador?){

         if casilla>=0 && casilla<=8{
             if tablero[casilla] == nil{
                 tablero[casilla] = TipoJugador.Humano

                 var ganador=AnalizaTablero()


                 if juegoActivo{
                     JugadaMaquina()
                 }


                 ganador=AnalizaTablero()


                 return (tablero,ganador)
             }
             else{
                 return (nil,nil)
             }
         }
         return (nil,nil)
     }


     private func AnalizaTablero()->TipoJugador?{

         var lix=0
         var jugadasHumano:Array<Int>=[0,0,0,0,0,0,0,0,0]
         var jugadasMaquina:Array<Int>=[0,0,0,0,0,0,0,0,0]

         var jugadorGanador:TipoJugador?=nil


         for objTipoJugador in tablero{

             if objTipoJugador==TipoJugador.Humano {

                 jugadasHumano[lix]=1
             }
             else if objTipoJugador==TipoJugador.Maquina{
                 jugadasMaquina[lix]=1
             }
             lix=lix+1
         }


         for jugadaGanadora in jugadasGanadoras{
             
             if jugadasHumano[jugadaGanadora.primerJugada]==1 && jugadasHumano[jugadaGanadora.segundaJugada] == 1 && jugadasHumano[jugadaGanadora.tercerJugada] == 1{
                 jugadorGanador = TipoJugador.Humano
                 break
             }
             if jugadasMaquina[jugadaGanadora.primerJugada]==1 && jugadasMaquina[jugadaGanadora.segundaJugada] == 1 && jugadasMaquina[jugadaGanadora.tercerJugada] == 1{
                 jugadorGanador = TipoJugador.Maquina

                 break
             }

         }

         juegoActivo=false

         if jugadorGanador != nil{
             juegoActivo=false
         }
         else{
             for objTipoJugador in tablero{
                 if objTipoJugador==nil {
                     juegoActivo=true
                     break
                 }
             }
         }
         
         
         
         return jugadorGanador
     }

 }
*/

