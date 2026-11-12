import wollok.game.*
import personaje.*
import salas.*
import estadoFinal.*
import temporizador.*
import items.*
import generadorDeSalas.*
import sonidos.*
import direcciones.*

object miJuego {
  var property nivelActual = 1
  var salaActual = null
  var juegoTerminado = false
  var ticksIniciados = false
    const latidoEnemigos = 100

  method salaActual() = salaActual
  
  method entrarA(sala) {
    game.allVisuals().forEach({ visual => game.removeVisual(visual) })
    salaActual = sala
    salaActual.inicializarse()
    game.addVisual(vida)
    game.addVisual(temporizador)
    game.addVisual(municionEquipada)
    game.addVisual(contadorEnemigos)
  }
  
  method esUltimaSala() = nivelActual == generadorDeSalas.cantidadDeSalas()
  
  method puedeJugar() = (!temporizador.preparando()) && (!juegoTerminado)
  
  method iniciarTicks() {
    if (!ticksIniciados) {
      ticksIniciados = true
      game.onTick(
        latidoEnemigos,
        "movimientoEnemigos",
        { if (self.puedeJugar()) salaActual.enemigosVivos().forEach(
              { enemigo => enemigo.pasarTiempo(latidoEnemigos) }
            ) }
      )
      game.onTick(1000, "timerSala", { temporizador.pasarSegundo() })
    }
  }
  
  method removerTicks() {
    if (ticksIniciados) {
      game.removeTickEvent("movimientoEnemigos")
      game.removeTickEvent("timerSala")
      ticksIniciados = false
    }
  }
  
  method iniciar() {
    nivelActual = 1
    juegoTerminado = false
    
    self.entrarA(generadorDeSalas.generarSala(nivelActual))
    self.iniciarTicks()
    
    game.onCollideDo(
      personaje,
      { elemento => personaje.reaccionarAColision(elemento) }
    )
    
    
    keyboard.w().whilePressedDo({ personaje.mover(arriba) }, 350)
    
    keyboard.a().whilePressedDo({ personaje.mover(izquierda) }, 350)
    
    keyboard.s().whilePressedDo({ personaje.mover(abajo) }, 350)
    
    keyboard.d().whilePressedDo({ personaje.mover(derecha) }, 100)
    
    keyboard.b().onPressDo({ personaje.cambiarMunicion() })
    
    keyboard.r().onPressDo({ self.reiniciar() })
    
    keyboard.space().onPressDo({ personaje.atacar() })
  }
  
  // Avanza al siguiente nivel cuando se cruza la puerta.
  method avanzarSala() {
    if (((!juegoTerminado) && salaActual.estaLimpia()) && salaActual.itemsAgarrados()) {
      if (self.esUltimaSala()) {
        self.ganarJuego()
      } else {
        nivelActual += 1
        self.entrarA(generadorDeSalas.generarSala(nivelActual))
      }
    }
  }
  
  // reicia el juego si se perdió la partida
  method reiniciar() {
    if (juegoTerminado) {
      juegoTerminado = false
      nivelActual = 1
      personaje.reiniciar()
      baulDePremios.reiniciarPremios()
      sonidos.iniciarMusica()
      self.iniciarTicks()
      self.entrarA(generadorDeSalas.generarSala(nivelActual))
    }
  }
  
  method reaccionarAPerdidaDeVida() {
    sonidos.sonidoDanio()
    
    game.say(
      personaje,
      "Ahora, mi cantidad de vida es: " + personaje.vidaActual()
    )
    
    if (personaje.vidaActual() == 0) {
      self.terminarJuego()
    } else {
      if (personaje.vidaActual() == 1) self.salaActual().aparecerPocionDeVida()
    }
  }
  
  method finalizarCon(estadoFinal) {
    if (!juegoTerminado) {
      juegoTerminado = true
      self.removerTicks()
      temporizador.detener()
      sonidos.detenerMusica()
      estadoFinal.ejecutar()
    }
  }
  
  method ganarJuego() {
    if (!juegoTerminado) {
      sonidos.sonidoVictoria()
      self.finalizarCon(victoria)
    }
  }
  
  method terminarJuego() {
    if (!juegoTerminado) {
      sonidos.sonidoDerrota()
      self.finalizarCon(derrota)
    }
  }
  
  method eliminarEnemigo(enemigo) {
    salaActual.eliminarEnemigo(enemigo)
    sonidos.muerteEnemigo()
    if (self.esUltimaSala() && salaActual.estaLimpia()) self.ganarJuego()
  }
}

object finDelJuego {
  method inicializarse() {
    miJuego.removerTicks()
    temporizador.detener()
    game.addVisual(personaje)
    miJuego.ganarJuego()
  }
  
  method enemigosVivos() = []
}

object vida {
  method position() = game.at(1, 0)
  
  method text() = "te quedan: " + personaje.vidaActual()
}

object municionEquipada {
  method position() = game.at(8, 0)
  
  method text() = "bala: " + personaje.municionActual().nombre()
}

object contadorEnemigos {
  method position() = game.at(3, 0)
  
  method text() = "enemigos: " + miJuego.salaActual().enemigosVivos().size()
}