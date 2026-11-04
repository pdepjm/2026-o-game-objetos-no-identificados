import wollok.game.*
import personaje.*
import temporizador.*

class Runa {
  const property nombre
  const property position

  method text() = nombre
  method esAtacable() = false

  method alColisionarConPersonaje() {
    puzzleFinal.pisar(self)
  }
}

object puzzleFinal {
  const orden = ["Luna", "Sol", "Estrella"]    // orden correcto: cambialo cuando quieras
  const pisadas = []
  var runas = []
  var bloqueado = false                        // evita que un mismo pisotón falle varias veces seguidas

  method orden() = orden
  method runas() = runas
  method pista() = pistaPuzzle

  // lo llama generadorDeSalas.sala15(); cada vez deja el puzzle en estado inicial
  method crearRunas() {
    pisadas.clear()
    bloqueado = false
    runas = [
      new Runa(nombre = "Sol", position = game.at(2, 5)),
      new Runa(nombre = "Luna", position = game.at(9, 5)),
      new Runa(nombre = "Estrella", position = game.at(5, 15))
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

// La pista se ve solo durante el "¡Prepárate!" y está en la fila de arriba,
// donde ni el personaje ni los enemigos pueden pisarla.
object pistaPuzzle {
  method position() = game.at(1, 19)
  method text() = if (temporizador.preparando()) "Memorizá: " + puzzleFinal.orden().join(" > ") else ""
  method esAtacable() = false
}