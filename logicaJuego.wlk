import wollok.game.*
import personaje.*
import salas.*

object miJuego {
  var salaActual = sala1
  var juegoTerminado = false

  method salaActual() = salaActual

  method entrarA(sala) {
    game.allVisuals().forEach { visual => game.removeVisual(visual) }
    salaActual = sala
    salaActual.inicializarse()
  }

  method iniciar() {
    self.entrarA(sala1)

    // los enemigos los define y los guarda cada sala; aca solo se le pregunta a la sala actual
    game.tick(500, { salaActual.enemigosVivos().forEach({ enemigo => enemigo.perseguir() }) }, false).start()

    game.onCollideDo(personaje, { elemento => personaje.reaccionarAColision(elemento) })

    keyboard.w().whilePressedDo({ personaje.mover(personaje.position().up(1)) }, 150)
    keyboard.a().whilePressedDo({ personaje.mover(personaje.position().left(1)) }, 150)
    keyboard.s().whilePressedDo({ personaje.mover(personaje.position().down(1)) }, 150)
    keyboard.d().whilePressedDo({ personaje.mover(personaje.position().right(1)) }, 150)

    game.onClickDo({ posicion => personaje.atacarEn(posicion) })
  }

  method terminarJuego() {
    if (!juegoTerminado) {
      juegoTerminado = true
      game.say(personaje, "Has perdido")
      game.schedule(2000, { game.stop() })
    }
  }

  method eliminarEnemigo(enemigo) {
    salaActual.eliminarEnemigo(enemigo)
  }
}
