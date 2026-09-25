import wollok.game.*
import personaje.*
import enemigos.*

object miJuego {
  const enemigos = [
    new EnemigoComun(position = game.at(3, 5)),
    new EnemigoComun(position = game.at(7, 2)),
    new EnemigoComun(position = game.at(10, 8))
  ]

  method iniciar() {
    const entidades = [personaje] ++ enemigos

    entidades.forEach({ entidad => game.addVisual(entidad) })

    game.tick(500, { enemigos.forEach({ enemigo => enemigos.perseguir() }) }, false).start()


    entidades.forEach({ entidad =>
      game.onCollideDo(entidad, { elemento => entidad.reaccionarAColision(elemento) })
    })

  }
}
