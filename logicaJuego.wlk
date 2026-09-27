import wollok.game.*
import personaje.*
import enemigos.*

object miJuego {
  // posicion provisional
  const enemigos = [
    new EnemigoComun(position = game.at(3, 5)),
    new EnemigoComun(position = game.at(7, 2)),
    new EnemigoComun(position = game.at(10, 8))
  ]

  method iniciar() {
    const entidades = [personaje] + enemigos

    entidades.forEach({ entidad => game.addVisual(entidad) })

    game.tick(500, { enemigos.forEach({ enemigo => enemigo.perseguir() }) }, false).start()


    entidades.forEach({ entidad =>
      game.onCollideDo(entidad, { elemento => entidad.reaccionarAColision(elemento) })
    })

    keyboard.w().whilePressedDo({personaje.moverArriba()}, 5)
    keyboard.a().whilePressedDo({personaje.moverIzquierda()}, 5)
    keyboard.s().whilePressedDo({personaje.moverAbajo()}, 5)
    keyboard.d().whilePressedDo({personaje.moverDerecha()}, 5)
  
    game.onClickDo({posicion => personaje.atacarEn(posicion)})

  }

  method terminarJuego(){
    game.say(self, "Has perdido")
    game.stop()
  }
}
