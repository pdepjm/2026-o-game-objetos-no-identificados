import logicaJuego.*
import salas.*


class puerta {
  
    var posicion = game.at(((game.width()-2)/2), (game.height()/2))
    var destino 
    var colisionable  = false  
    
    method desbloquear(){
        colisionable = true
    }

    method reaccionarAColision() {
        if(colisionable){ 
            miJuego.entrarA(destino)
            
        }
        
    }
}