
import wollok.game.*
import personaje.*

class EstadoFinal {
    const mensaje

    method ejecutar() {
    game.say(personaje, mensaje)
    game.schedule(2000, { game.stop() })
    }
}

object victoria {
    method ejecutar() {
        new EstadoFinal(mensaje = "¡Has ganado!").ejecutar()
    }
}

object derrota {
    method ejecutar() {
        new EstadoFinal(mensaje = "Has perdido").ejecutar()
    }
}