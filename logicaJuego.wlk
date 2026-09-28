import wollok.game.*
import personaje.*
import enemigos.*

object miJuego {
  // posicion provisional
  const enemigos = [
    new Enemigo(position = game.at(3, 5)),
    new Enemigo(position = game.at(7, 2)),
    new Enemigo(position = game.at(10, 8))
  ]

  method iniciar() {
    const entidades = [personaje] + enemigos

    entidades.forEach({ entidad => game.addVisual(entidad) })

    game.tick(500, { enemigos.forEach({ enemigo => enemigo.perseguir() }) }, false).start()


    entidades.forEach({ entidad =>
      game.onCollideDo(entidad, { elemento => entidad.reaccionarAColision(elemento) })
    })

    keyboard.w().whilePressedDo({personaje.mover(personaje.position().up(1))}, 1)
    keyboard.a().whilePressedDo({personaje.mover(personaje.position().left(1))}, 1)
    keyboard.s().whilePressedDo({personaje.mover(personaje.position().down(1))}, 1)
    keyboard.d().whilePressedDo({personaje.mover(personaje.position().right(1))}, 1)
  
    game.onClickDo({posicion => personaje.atacarEn(posicion)})

  }

  method terminarJuego(){
    game.say(self, "Has perdido")
    game.stop()
  }

  method eliminarEnemigo(enemigo) {
    game.removeVisual(enemigo)
    enemigos.remove(enemigo)
  }

  
}
