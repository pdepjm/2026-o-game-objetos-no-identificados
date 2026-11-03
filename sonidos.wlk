import wollok.game.*

object sonidos {
  var musicaFondo = null

  method iniciarMusica() {
    musicaFondo = game.sound("musica-fondo.mp3")
    musicaFondo.shouldLoop(true)
    musicaFondo.play()
  }

  method detenerMusica() {
    if (musicaFondo != null) {
      musicaFondo.stop()
    }
  }

  method reproducirSonido(archivo) {
    game.sound(archivo).play()
  }

  method sonidoDisparo() {
    self.reproducirSonido("disparo.wav")
  }

  method sonidoDanio() {
    self.reproducirSonido("danio.wav")
  }

  method sonidoObjeto() {
    self.reproducirSonido("objeto.wav")
  }

  method sonidoVictoria() {
    self.reproducirSonido("victoria.wav")
  }

  method sonidoDerrota() {
    self.reproducirSonido("derrota.wav")
  }
}