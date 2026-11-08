import wollok.game.*
import logicaJuego.*

object menuFondo {
  method position() = game.at(0, 0)
  
  method image() = "menu_fondo.png"
}

object titulo {
  method position() = game.at(1, game.center().y() + 3)
  
  method image() = "menu_titulo.png"
}

class OpcionDeMenu {
  const orden
  const imagen
  const imagenSeleccionada
  const accion
  
  method position() = game.at(3, game.center().y() - (orden * 2))
  
  method image() = if (menu.seleccionada() == self) imagenSeleccionada
                   else imagen
  
  method ejecutar() {
    accion.apply()
  }
}

class LineaDeTexto {
  const property position
  const property text
  
  method textColor() = "FFFFFF"
}

object pantallaControles {
  const lineas = [
    new LineaDeTexto(position = game.at(3, 15), text = "CONTROLES"),
    new LineaDeTexto(position = game.at(2, 12), text = "W A S D: moverse"),
    new LineaDeTexto(position = game.at(2, 11), text = "ESPACIO: disparar"),
    new LineaDeTexto(position = game.at(2, 10), text = "B: cambiar de bala"),
    new LineaDeTexto(position = game.at(2, 9), text = "R: reiniciar al perder"),
    new LineaDeTexto(position = game.at(2, 5), text = "ENTER: volver")
  ]
  
  method mostrar() {
    lineas.forEach({ linea => game.addVisual(linea) })
  }
  
  method ocultar() {
    lineas.forEach({ linea => game.removeVisual(linea) })
  }
}

object menu {
  const opciones = [
    new OpcionDeMenu(
      orden = 0,
      imagen = "btn_jugar.png",
      imagenSeleccionada = "btn_jugar_sel.png",
      accion = { self.jugar() }
    ),
    new OpcionDeMenu(
      orden = 1,
      imagen = "btn_controles.png",
      imagenSeleccionada = "btn_controles_sel.png",
      accion = { self.verControles() }
    ),
    new OpcionDeMenu(
      orden = 2,
      imagen = "btn_salir.png",
      imagenSeleccionada = "btn_salir_sel.png",
      accion = { game.stop() }
    )
  ]
  var indice = 0
  var activo = false
  var viendoControles = false
  
  method seleccionada() = opciones.get(indice)
  
  method iniciar() {
    self.configurarTeclas()
    self.mostrar()
  }
  
  method configurarTeclas() {
    keyboard.w().onPressDo({ self.subir() })
    keyboard.s().onPressDo({ self.bajar() })
    keyboard.enter().onPressDo({ self.confirmar() })
  }
  
  method mostrar() {
    activo = true
    game.addVisual(menuFondo)
    self.mostrarOpciones()
  }
  
  method mostrarOpciones() {
    game.addVisual(titulo)
    opciones.forEach({ opcion => game.addVisual(opcion) })
  }
  
  method ocultarOpciones() {
    game.removeVisual(titulo)
    opciones.forEach({ opcion => game.removeVisual(opcion) })
  }
  
  method subir() {
    if (self.puedeNavegar()) {
      indice = (indice - 1).max(0)
    }
  }
  
  method bajar() {
    if (self.puedeNavegar()) {
      indice = (indice + 1).min(opciones.size() - 1)
    }
  }
  
  method puedeNavegar() = activo && (!viendoControles)
  
  method confirmar() {
    if (activo) {
      if (viendoControles) self.volver() else self.seleccionada().ejecutar()
    }
  }
  
  method verControles() {
    viendoControles = true
    self.ocultarOpciones()
    pantallaControles.mostrar()
  }
  
  method volver() {
    viendoControles = false
    pantallaControles.ocultar()
    self.mostrarOpciones()
  }
  
  method jugar() {
    activo = false
    miJuego.iniciar()
  }
}