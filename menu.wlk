import wollok.game.*
import logicaJuego.*

object menuFondo {                                   
  method position() = game.at(0, 0)
  method image() = "menu_fondo.png"
}

class OpcionDeMenu {
  const orden
  const imagen                                       
  const imagenSeleccionada                          
  const accion

  method position() = game.at(3, game.center().y() - orden * 2)  
  method image() = if (menu.seleccionada() == self) imagenSeleccionada else imagen   
  method ejecutar() { accion.apply() }
}

object titulo {
  method position() = game.at(1, game.center().y() + 3)   
  method image() = "menu_titulo.png"                       
}

object menu {
  const opciones = [
    new OpcionDeMenu(orden = 0,                                        
                     imagen = "btn_jugar.png",
                     imagenSeleccionada = "btn_jugar_sel.png",
                     accion = { self.jugar() }),
    new OpcionDeMenu(orden = 1,
                     imagen = "btn_salir.png",
                     imagenSeleccionada = "btn_salir_sel.png",
                     accion = { game.stop() })
  ]
  var indice = 0
  var activo = false

  method seleccionada() = opciones.get(indice)

  method iniciar() {
    self.configurarTeclas()
    self.mostrar()
  }

  method configurarTeclas() {
    keyboard.up().onPressDo({ self.subir() })
    keyboard.down().onPressDo({ self.bajar() })
    keyboard.enter().onPressDo({ self.confirmar() })
  }

  method mostrar() {
    activo = true
    game.addVisual(menuFondo)                        
    game.addVisual(titulo)
    opciones.forEach({ opcion => game.addVisual(opcion) })
  }

  method subir() { if (activo) indice = (indice - 1).max(0) }
  method bajar() { if (activo) indice = (indice + 1).min(opciones.size() - 1) }
  method confirmar() { if (activo) self.seleccionada().ejecutar() }

  method jugar() {
    activo = false
    miJuego.iniciar()
  }
}