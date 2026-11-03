import wollok.game.*

object sonidos {
  var musicaFondo = null

  method iniciarMusica() {
    musicaFondo = game.sound("Musica.mp3")
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
    self.reproducirSonido("Disparo.mp3")
  }

  method sonidoDanio() {
    self.reproducirSonido("Recibir daño.mp3")
  }

  method sonidoObjeto() {
    self.reproducirSonido("Recoger objetos.mp3")
  }

  method sonidoVictoria() {
    self.reproducirSonido("Victoria.mp3")
  }

  method sonidoDerrota() {
    self.reproducirSonido("derrota.wav")
  }
}