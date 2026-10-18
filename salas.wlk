import wollok.game.*
import enemigos.*
import personaje.*
import puerta.*
import logicaJuego.*
import generadorDeMonstruos.*
import temporizador.*
import obstaculos.*
import paredes.*

class Sala {
  var enemigosVivos = []
  // se crea en inicializarse(), asi cada vez que se entra la puerta arranca bloqueada
  var puerta = null

  method tiempoLimite()   // cada sala define sus segundos

  // cada sala define esto
  method fondo()
  method crearEnemigos()
  method puntoDeEntrada()
  method salaSiguiente()

  // cada sala define sus paredes internas (por defecto, ninguna)
  method paredes() = []

  method inicializarse() {
    temporizador.iniciar(self.tiempoLimite()) // cada sala define su tiempo limite
    game.boardGround(self.fondo())

// las paredes van primero para que queden debajo de enemigos y personaje
    paredes.construir(self.paredes())

    enemigosVivos = self.crearEnemigos()
    enemigosVivos.forEach { enemigo =>
      game.addVisual(enemigo)
      game.onCollideDo(enemigo, { elemento => enemigo.reaccionarAColision(elemento) })
    }

    puerta = new Puerta(destino = self.salaSiguiente())
    game.addVisual(puerta)

    game.addVisual(personaje)
    personaje.position(self.puntoDeEntrada())
  }

  method enemigosVivos() = enemigosVivos

  method puerta() = puerta

  method estaLimpia() = enemigosVivos.isEmpty()

  method eliminarEnemigo(enemigo) {
    game.removeVisual(enemigo)
    enemigosVivos.remove(enemigo)
    if (self.estaLimpia()) puerta.desbloquear()
  }
}

object sala1 inherits Sala {
  override method fondo() = "sala1.png"
  override method tiempoLimite() = 20  // 20 segundos para limpiar la sala

  override method paredes() =
    paredes.horizontal(1, 6, 9) +
    paredes.horizontal(4, game.width() - 2, 14)

  override method crearEnemigos() = 
    generadorDeMonstruos.generarEnemigosEn([
      game.at(4, 5),
      game.at(8, 7),
      game.at(5, 12)
    ])

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala2
}

object sala2 inherits Sala {
  override method fondo() = "sala2.png"
  override method tiempoLimite() = 25 // segundos

override method paredes() =
    paredes.vertical(6, 2, 11) +
    paredes.horizontal(1, 5, 14)

  override method crearEnemigos() = 
    generadorDeMonstruos.generarEnemigosEn([
      game.at(3, 5),
      game.at(9, 5),
      game.at(5, 9),
      game.at(8, 13),
      game.at(2, 15)
    ])

  override method puntoDeEntrada() = game.at(5, 1)

  
  override method salaSiguiente() = finDelJuego
}