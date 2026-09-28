import wollok.game.*
import enemigos.*
import personaje.*
import puerta.*

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

  // posicion provisional
  override method crearEnemigos() = [
    new Enemigo(position = game.at(1, 2)),
    new Enemigo(position = game.at(3, 4)),
    new Enemigo(position = game.at(5, 6))
  ]

  override method puntoDeEntrada() = game.at(1, 1)

  override method salaSiguiente() = sala2
}

object sala2 inherits Sala {
  override method fondo() = "sala2.png"

  // posicion provisional
  override method crearEnemigos() = [
    new Enemigo(position = game.at(1, 2)),
    new Enemigo(position = game.at(3, 4)),
    new Enemigo(position = game.at(5, 6)),
    new Enemigo(position = game.at(7, 8)),
    new Enemigo(position = game.at(9, 10))
  ]

  override method puntoDeEntrada() = game.at(1, 1)

  // provisional: todavia no existe la sala final, por ahora vuelve a sala1
  override method salaSiguiente() = sala1
}
