import wollok.game.*
import personaje.*
import salas.*
import estadoFinal.*
import temporizador.*


object miJuego {
  var salaActual = sala1
  var juegoTerminado = false

  method salaActual() = salaActual

  method entrarA(sala) {
    game.allVisuals().forEach { visual => game.removeVisual(visual) }
    salaActual = sala
    salaActual.inicializarse()
    game.addVisual(vida)
    game.addVisual(temporizador)
  }

  method puedeJugar() = !temporizador.preparando() && !juegoTerminado

  method iniciar() {
    self.entrarA(sala1)
    temporizador.iniciarPreparacion(5)

    // los enemigos los define y los guarda cada sala; aca solo se le pregunta a la sala actual
    //game.tick(500, { salaActual.enemigosVivos().forEach({ enemigo => enemigo.perseguir() }) }, false).start()
    game.onTick(500, "movimientoEnemigos", {
       if (self.puedeJugar()) salaActual.enemigosVivos().forEach({enemigo => enemigo.perseguir()})
     })
    game.onTick(1000, "timerSala", { temporizador.pasarSegundo() })
    game.onCollideDo(personaje, { elemento => personaje.reaccionarAColision(elemento) })

    keyboard.w().whilePressedDo({ personaje.mover(personaje.position().up(1)) }, 150)
    keyboard.a().whilePressedDo({ personaje.mover(personaje.position().left(1)) }, 150)
    keyboard.s().whilePressedDo({ personaje.mover(personaje.position().down(1)) }, 150)
    keyboard.d().whilePressedDo({ personaje.mover(personaje.position().right(1)) }, 150)
    keyboard.r().onPressDo({ self.reiniciar() }) // reinicia el juego si se perdió
    game.onClickDo({ posicion => personaje.atacarEn(posicion) })
  }

// reicia el juego si se perdió la partida
method reiniciar() {
   if (juegoTerminado) {
     juegoTerminado = false
      personaje.reiniciar()
      self.entrarA(sala1)
      temporizador.iniciarPreparacion(5)
    }
  }

  method finalizarCon(estadoFinal) {
    if(!juegoTerminado) {
      juegoTerminado = true
      temporizador.detener()
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
    temporizador.detener()
    game.addVisual(personaje)
    miJuego.ganarJuego()
  }

  method enemigosVivos() = []
}


object vida {
  method position() = game.at(1,0)
  method text() = "te quedan: " + personaje.vidaActual()
}