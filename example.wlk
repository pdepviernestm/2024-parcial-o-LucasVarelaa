class Persona{
    var emociones = []
    var property edad
    var property eventosVividos = 0

    method esAdolescente() = edad.between(12, 19)

    method tenerUnaEmocion(emocion) {
        emociones.add(emocion)
        }
        
    method cantEmociones() = emociones.size()
    
    method estaPorExplotar() = emociones.all{ e => e.puedeLiberarse() }

    method vivir(evento){
        emociones.forEach{ emocion => emocion.intentarLiberarse(evento)}
        eventosVividos += 1
    }

}

object global{
    var property intensidadLimite = 10
    var personas = []

    method agregarPersona(persona){  
         personas.add(persona)
    }

    method cantPersonasPorExplotar() = personas.count{ persona => persona.estaPorExplotar() } 

    method todosViven(evento){
        personas.forEach{ persona => persona.vivir(evento) }
    }
}

class Emocion{
    var property intensidad 
    var property cantEventos = 0

    method puedeLiberarse() = intensidad > global.intensidadLimite() && self.condicionAdicional()

    method liberarse(evento){
        intensidad -= evento.impacto()
    }

    method intentarLiberarse(evento){
        if(self.puedeLiberarse()){
            self.liberarse(evento)
            cantEventos += 1
        }
        // else{
        //     throw new Exception(message = "No se puede liberar la emoción")
        // }
    }

    method condicionAdicional()
}

class Evento{
    var property impacto
    var property descripcion
}

class Furia inherits Emocion(intensidad=100){
    var palabrotas = []

    method aprenderPalabrota(palabrabrota){
        palabrotas.add(palabrabrota)
        }

    override method condicionAdicional() = palabrotas.any{ palabrota => palabrota.size() >= 7 }

    override method liberarse(evento){
        super(evento)
        palabrotas.remove(palabrotas.first())
        
    }
}

class Alegria inherits Emocion{

    override method condicionAdicional() = cantEventos.even()
    
    override method intensidad(valor){
        intensidad = valor.abs()
    }
}

class Tristeza inherits Emocion {
    var property causa = "melancolia"

    override method condicionAdicional() = causa != "melancolia"

    override method liberarse(evento){
        super(evento)
        causa = evento.descripcion()
    } 
}

class DesagradoTemor inherits Emocion {

    override method condicionAdicional() = cantEventos > intensidad
}

class Ansiedad inherits Emocion{
    var pensamientosRepetitivos = 0

    override method liberarse(evento) {
      super(evento)
      pensamientosRepetitivos = 0
      }

    override method condicionAdicional() = intensidad > global.intensidadLimite() && pensamientosRepetitivos > 5
    
}

/*
Al hacer que las subclases hereden de Emocion, aprovechamos comportamientos ya definidos, como la lógica básica de liberación y 
la estructura de las condiciones de liberación. Esto evita repetir código y garantiza consistencia en cómo las 
emociones funcionan dentro del sistema. Gracias a super y override, podemos redefinir comportamientos y condiciones sin modificar 
la clase base. Esto nos permite ya establecer un comportamiento habitual entre las emociones y al usar super evitamos repertir codigo

El polimorfismo permite que cada emoción tenga su propia implementación específica de métodos como condicionAdicional o liberarse. 
Aunque todas las emociones comparten la interfaz común definida en Emocion, cada una aporta su propia lógica particular, si es que lo necesita,
sino simplemente se va a heredar de Emocion. 

Estos dos conceptos nos sirven tambien para implementaciones futuras, ya que si se agrega una nueva emoción
o se modifica el comportamiento de una existente, podemos hacerlo redefiniendo métodos sin afectar a otras clases. 

Y por ultimo al estructurar el sistema jerárquicamente (con Emocion como la clase base y sus subclases como implementaciones concretas), 
se establece una representación clara del dominio del problema, facilitando el mantenimiento y la comprensión del código. Aprender todos
estos conceptos espero que nos sirvan para que el dia de maniana podamos hacer proyectos con todos conocimientos.

*/
