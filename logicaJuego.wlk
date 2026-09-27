import wollok.game.*
import personaje.*
import enemigos.*


object temporizador {
  var tiempoRestante = 20

  method position() = game.at(1, game.height() - 2)
  method text() = "Tiempo: " + tiempoRestante
  method textColor() = "FF0000FF"

  method decrementar() {
    tiempoRestante = tiempoRestante - 1
    if (tiempoRestante <= 0) {
      miJuego.terminarJuego()
    }
  }
}

object pantallaDerrota {
  method position() = game.center()
  method text() = "GAME OVER"
  method textColor() = "FF0000FF"
  method image() = "textoFinal.png"
}

object miJuego {
  const enemigos = [
    new EnemigoComun(position = game.at(3, 5)),
    new EnemigoComun(position = game.at(7, 2)),
    new EnemigoComun(position = game.at(10, 8))
  ]
var tickTimer = null

  method iniciar() {
    const entidades = [personaje] + enemigos

    entidades.forEach({ entidad => game.addVisual(entidad)
     game.say(entidad, entidad.image())
    })

    game.tick(500, { enemigos.forEach({ enemigo => enemigo.perseguir() }) }, false).start()

    entidades.forEach({ entidad =>
      game.onCollideDo(entidad, { elemento => entidad.reaccionarAColision(elemento) })
    })


    keyboard.w().whilePressedDo({personaje.moverArriba()}, 5)
    keyboard.a().whilePressedDo({personaje.moverIzquierda()}, 5)
    keyboard.s().whilePressedDo({personaje.moverAbajo()}, 5)
    keyboard.d().whilePressedDo({personaje.moverDerecha()}, 5)
  
    game.onClickDo({posicion => personaje.atacarEn(posicion)})

    game.addVisual(temporizador)
    tickTimer = game.tick(1000, { temporizador.decrementar() }, false)
    tickTimer.start()

  }


method terminarJuego() {
  tickTimer.stop()
  game.addVisual(pantallaDerrota)
  game.say(personaje, "El personaje fue derrotado")
  game.stop()
}

}
