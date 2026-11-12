import wollok.game.*
import personaje.*
import temporizador.*

class Runa {
  const property nombre
  const property image
  const property position

  method esAtacable() = false

  method alColisionarConPersonaje(unPersonaje) {
    puzzleFinal.pisar(self)
  }
}

object puzzleFinal {
  const orden = ["Luna", "Sol", "Estrella"]    // orden correcto: cambialo cuando quieras
  const pisadas = []
  var runas = []
  var bloqueado = false 

  method orden() = orden
  method runas() = runas
  method pista() = pistaPuzzle
  
  // lo llama generadorDeSalas.sala9(); cada vez deja el puzzle en estado inicial
  method crearRunas() {
    pisadas.clear()
    bloqueado = false
      runas = [
      new Runa(nombre = "Sol", image = "runa_sol.png", position = game.at(10, 10)),            
      new Runa(nombre = "Luna", image = "runa_luna.png", position = game.at(1, 16)),           
      new Runa(nombre = "Estrella", image = "runa_estrella.png", position = game.at(1, 2))     
    ]
    return runas
  }

  method pisar(runa) {
    if (!bloqueado) {
      if (runa.nombre() == orden.get(pisadas.size())) {
        self.acertar(runa)
      } else {
        self.fallar()
      }
    }
  }

  method acertar(runa) {
    game.removeVisual(runa)
    pisadas.add(runa)
    game.say(personaje, "¡Bien! " + pisadas.size() + "/" + orden.size())
  }

  method fallar() {
    bloqueado = true
    game.schedule(1000, { bloqueado = false })
    pisadas.forEach({ runa => game.addVisual(runa) })
    pisadas.clear()
    game.say(personaje, "¡Orden equivocado! Perdés 5 segundos")
    temporizador.restarSegundos(5)
  }
}

// La pista se ve solo durante el "¡Prepárate!"
object pistaPuzzle {
  method image() = if (temporizador.preparando()) "pista_puzzle.png" else "vacio.png"     
  method position() = game.at(2, 19)         
  method esAtacable() = false
}