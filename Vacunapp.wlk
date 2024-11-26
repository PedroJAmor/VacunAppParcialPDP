object calendarioHoy{
  method hoy() = new Date()
}


class Persona{
  var property nombre
  var property edad
  var property calendario = calendarioHoy

  var property inmunidad
  var property anticuerpos    
}


class Vacuna{
  method aplicar(persona){
    self.aumentarAnticuerpos(persona)
    self.aumentarInmunidad(persona)
  }

  method aumentarAnticuerpos(persona)
  method aumentarInmunidad(persona) 
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

  method personaPrueba(persona) = new Persona(
    nombre = persona.nombre(),
    edad = persona.edad(),
    inmunidad = persona.inmunidad(),
    anticuerpos = persona.anticuerpos(),
    calendario = persona.calendario()
  )

  method menorAnticuerpos(persona) = self.anticuerposAplicada(persona).min()
  method anticuerposAplicada(persona) = vacunas.map{vacuna => self.anticuerposVacunaAplicada(persona, vacuna)}

  method anticuerposVacunaAplicada(persona, vacuna){
    const personaPrueba = self.personaPrueba(persona)
    vacuna.aplicar(personaPrueba)
    return personaPrueba.anticuerpos()
  }


  method mayorInmunidad(persona) = self.inmunidadAplicada(persona).max()
  method inmunidadAplicada(persona) = vacunas.map{vacuna => self.inmunidadVacunaAplicada(persona, vacuna)}

  method inmunidadVacunaAplicada(persona, vacuna){
    const personaPrueba = self.personaPrueba(persona)
    vacuna.aplicar(personaPrueba)
    return personaPrueba.inmunidad()
  } 
}

//Punto 2








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

const personaP = fixtureP.crearPersona()
const fechaInmunidad = new Date(day = 1, year = 2024, month = 10)
const combineta = new Combineta(vacunas = [paifer, astraLaVistaZeneca, new Larussa(multiplicador = 1)])
*/