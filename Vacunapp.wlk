object calendarioHoy{
  method hoy() = new Date()
}


class Persona{
  var property nombre
  var property edad
  var property calendario = calendarioHoy
  var property provincia = "Buenos Aires"
  const provinciasEspeciales =["Tierra del Fuego", "Santa Cruz", "Neuquén"]
  var property preferenciaVacuna = cualquierosa

  var property inmunidad
  var property anticuerpos    

  method elige(vacuna) = preferenciaVacuna.elige(vacuna, self)
  method esEspecial() = provinciasEspeciales.contains(provincia)

  method personaAux() = new Persona(
    nombre = nombre,
    edad = edad,
    inmunidad = inmunidad,
    anticuerpos = anticuerpos,
    calendario = calendario
  )

}


class Vacuna{
  method aplicar(persona){
    self.aumentarAnticuerpos(persona)
    self.aumentarInmunidad(persona)
  }

  method aumentarAnticuerpos(persona)
  method aumentarInmunidad(persona) 

  method costo(persona) = self.costoDeVacuna(persona) + self.costoParticular(persona)

  method costoDeVacuna(persona) = 1000 + 50 * self.aniosMasDe30(persona)
  method aniosMasDe30(persona) = (persona.edad() - 30).max(0)

  method costoParticular(persona)
}
object paifer inherits Vacuna{

  override method aumentarAnticuerpos(persona){
    const _anticuerpos = persona.anticuerpos() * 10
    persona.anticuerpos(_anticuerpos)
  } 
  
  override method aumentarInmunidad(persona){
    const meses = if (persona.edad() > 40) 6 else 9
    const fechaInmunidad = persona.calendario().hoy().plusMonths(meses)
    persona.inmunidad(fechaInmunidad) 
  }

  override method costoParticular(persona) = if(persona.edad() < 18) 400 else 100
}

class Larussa inherits Vacuna{
  const multiplicador

  override method aumentarAnticuerpos(persona) {
    const _anticuerpos = multiplicador.min(20) * persona.anticuerpos()
    persona.anticuerpos(_anticuerpos)
  }

  override method aumentarInmunidad(persona) {
    const fechaInmunidad = new Date(day = 03, month = 03, year = 2024)
    persona.inmunidad(fechaInmunidad)
  }
  override method costoParticular(persona) = 100 * multiplicador.min(20)
}

object astraLaVistaZeneca inherits Vacuna{
  override method aumentarInmunidad(persona){
    const meses = if (persona.nombre().length().even()) 6 else 7
    const fechaInmunidad = persona.calendario().hoy().plusMonths(meses)
    persona.inmunidad(fechaInmunidad)
  }

  override method aumentarAnticuerpos(persona){
    const _anticuerpos = persona.anticuerpos() + 10000
    persona.anticuerpos(_anticuerpos)
  }

  override method costoParticular(persona) = if(persona.esEspecial()) 2000 else 0
}

class Combineta inherits Vacuna{
  const vacunas = [] 

  override method aumentarInmunidad(persona){
    const _inmunidad = self.mayorInmunidad(persona)
    persona.inmunidad(_inmunidad)
  } 

  override method aumentarAnticuerpos(persona){
    const _anticuerpos = self.menorAnticuerpos(persona)
    persona.anticuerpos(_anticuerpos)
  }

  method personaAux(persona) = new Persona(
    nombre = persona.nombre(),
    edad = persona.edad(),
    inmunidad = persona.inmunidad(),
    anticuerpos = persona.anticuerpos(),
    calendario = persona.calendario()
  )

  method menorAnticuerpos(persona) = self.anticuerposAplicada(persona).min()
  method anticuerposAplicada(persona) = vacunas.map{vacuna => self.anticuerposVacunaAplicada(persona, vacuna)}

  method anticuerposVacunaAplicada(persona, vacuna){
    const personaAux = persona.personaAux()
    vacuna.aplicar(personaAux)
    return personaAux.anticuerpos()
  }


  method mayorInmunidad(persona) = self.inmunidadAplicada(persona).max()
  method inmunidadAplicada(persona) = vacunas.map{vacuna => self.inmunidadVacunaAplicada(persona, vacuna)}

  method inmunidadVacunaAplicada(persona, vacuna){
    const personaAux = persona.personaAux()
    vacuna.aplicar(personaAux)
    return personaAux.inmunidad()
  } 
  override method costoDeVacuna(persona) = vacunas.sum{vacuna => vacuna.costo(persona)}
  override method costoParticular(persona) = 100 * vacunas.size()
}

//Punto 3

object cualquierosa {
  method elige(vacuna, persona) = true
}

object anticuerposa{

  method personaAux(persona) = new Persona(
    nombre = persona.nombre(),
    edad = persona.edad(),
    inmunidad = persona.inmunidad(),
    anticuerpos = persona.anticuerpos(),
    calendario = persona.calendario()
  )

  method elige(vacuna, persona) {
    const personaAux = persona.personaAux()
    vacuna.aplicar(personaAux)
    return personaAux.anticuerpos() > 100000
  }
}

object inmunidosaFija{
  const fecha = new Date(day = 5, month = 3, year = 2024)

  method elige(vacuna, persona){
    const personaAux = persona.personaAux()
    vacuna.aplicar(personaAux)
    return personaAux.inmunidad() >= fecha 
  } 
}

class InmunidosaVariable{
  const meses

  method elige(vacuna, persona){
    const fecha = persona.calendario().hoy().plusMonths(meses)
    const personaAux = persona.personaAux()
    vacuna.aplicar(personaAux)
    return personaAux.inmunidad() > fecha
  }

}






/*
object calendarioStub {
  var property _day = 1
  var property _month = 1
  var property _year = 2024
  method hoy() = new Date(day = _day, month = _month, year = _year)
}

object fixtureP{
  method crearPersona() = new Persona(anticuerpos=1000,
    edad=22,
    inmunidad = new Date(),
    calendario = calendarioStub,
    nombre = "")
}
*/