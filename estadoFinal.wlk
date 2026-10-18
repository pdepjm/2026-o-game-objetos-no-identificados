
import wollok.game.*
import personaje.*

class EstadoFinal {
    const mensaje

    method ejecutar() {
    game.say(personaje, mensaje)
    game.schedule(2000, { game.stop() })
    }
}
object pantallaFinal {
    var mensaje = ""

    method position() = game.center()
    method text() = mensaje
    method esAtacable() = false

    method mostrar(texto) {
        mensaje = texto
        game.addVisual(self)
    }
}

object victoria {
    method ejecutar() {
        new EstadoFinal(mensaje = "¡Has ganado!").ejecutar()
    }
}

object derrota {
    method ejecutar() {
        pantallaFinal.mostrar("Has perdido. Presioná R para reiniciar")
    }
}