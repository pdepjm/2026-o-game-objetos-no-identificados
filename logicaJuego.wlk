import wollok.game.*
import personaje.*
import enemigos.*
import puerta.*

object miJuego {
  // posicion provisional


  var salaActual= sala1
 



  method entrarA(sala) {
    game.allVisuals().forEach { v => game.removeVisual(v) }
    salaActual= sala
    salaActual.inicializarse()
  }



  method iniciar() {
    const entidades = [personaje] + salaActual.enemigos
    self.entrarA(sala1)
    entidades.forEach({ entidad => game.addVisual(entidad) })

    game.tick(500, { salaActual.enemigos.forEach({ enemigo => enemigo.perseguir() }) }, false).start()


    entidades.forEach({ entidad => game.onCollideDo(entidad, { elemento => entidad.reaccionarAColision(elemento) })
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
<<<<<<< HEAD
    salaActual.enemigos.remove(enemigo)
    if (salaActual.enemigos.isEmpty()) puerta.desbloquear()
=======
    enemigos.remove(enemigo)
    if (enemigos.isEmpty()) puerta.desbloquear()
>>>>>>> a138d42105ac792ff2f64ce82485791258286856
  }

  
}
