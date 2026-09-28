import wollok.game.*
import logicaJuego.*

class Puerta {
  var property position = game.at((game.width() - 2).div(2), game.height().div(2))
  const destino
  var desbloqueada = false

  // ojo: falta el asset puerta.png en la carpeta assets
  method image() = "puerta.png"

  method esAtacable() = false

  method desbloquear() {
    desbloqueada = true
  }

  method alColisionarConPersonaje() {
    if (desbloqueada) miJuego.entrarA(destino)
  }
}
