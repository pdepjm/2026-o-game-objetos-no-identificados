import wollok.game.*
import personaje.*
import salas.*
import estadoFinal.*


object miJuego {
  var salaActual = sala1
  var juegoTerminado = false

  method salaActual() = salaActual

  method entrarA(sala) {
    game.allVisuals().forEach { visual => game.removeVisual(visual) }
    salaActual = sala
    game.addVisual(vida)
    salaActual.inicializarse()
  }

  method iniciar() {
    self.entrarA(sala1)

    // los enemigos los define y los guarda cada sala; aca solo se le pregunta a la sala actual
    //game.tick(500, { salaActual.enemigosVivos().forEach({ enemigo => enemigo.perseguir() }) }, false).start()

    game.onTick(500, "movimientoEnemigos", { salaActual.enemigosVivos().forEach({enemigo => enemigo.perseguir()})})
    game.onCollideDo(personaje, { elemento => personaje.reaccionarAColision(elemento) })

    keyboard.w().whilePressedDo({ personaje.mover(personaje.position().up(1)) }, 150)
    keyboard.a().whilePressedDo({ personaje.mover(personaje.position().left(1)) }, 150)
    keyboard.s().whilePressedDo({ personaje.mover(personaje.position().down(1)) }, 150)
    keyboard.d().whilePressedDo({ personaje.mover(personaje.position().right(1)) }, 150)

    game.onClickDo({ posicion => personaje.atacarEn(posicion) })
  }

  method finalizarCon(estadoFinal) {
    if(!juegoTerminado) {
      juegoTerminado = true
      estadoFinal.ejecutar()
    }
  }

  method ganarJuego() {
    self.finalizarCon(victoria)
  }

  method terminarJuego() {
    self.finalizarCon(derrota)
  }

  method eliminarEnemigo(enemigo) {
    salaActual.eliminarEnemigo(enemigo)
  }
}

object finDelJuego {
  method inicializarse() {
    game.addVisual(personaje)
    miJuego.ganarJuego()
  }

  method enemigosVivos() = []
}


object vida {
  method position() = game.at(1,0)
  method text() = "te quedan: " + personaje.vidaActual()
}