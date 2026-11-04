
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
    method position() = game.at(1, 7)                  
    method image() = "pantalla_derrota.png"            
    method esAtacable() = false
    method alColisionarConPersonaje() {}              

    method mostrar() {                                 
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
    pantallaFinal.mostrar() 
    }
}