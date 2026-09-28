import wollok.game.*
import enemigos.*
import personaje.*
import puerta.*
import logicaJuego.*

class Sala {
  var enemigosVivos = []
  // se crea en inicializarse(), asi cada vez que se entra la puerta arranca bloqueada
  var puerta = null

  // cada sala define esto
  method fondo()
  method crearEnemigos()
  method puntoDeEntrada()
  method salaSiguiente()

  method inicializarse() {
    game.boardGround(self.fondo())

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

  
  override method crearEnemigos() = [
    new Enemigo(position = game.at(4, 5)),
    new Enemigo(position = game.at(8, 7)),
    new Enemigo(position = game.at(5, 12))
  ]

  override method puntoDeEntrada() = game.at(5, 1)

  override method salaSiguiente() = sala2
}

object sala2 inherits Sala {
  override method fondo() = "sala2.png"

  
  override method crearEnemigos() = [
    new Enemigo(position = game.at(3, 5)),
    new Enemigo(position = game.at(9, 5)),
    new Enemigo(position = game.at(5, 9)),
    new Enemigo(position = game.at(8, 13)),
    new Enemigo(position = game.at(2, 15))
  ]

  override method puntoDeEntrada() = game.at(5, 1)

  
  override method salaSiguiente() = finDelJuego
}