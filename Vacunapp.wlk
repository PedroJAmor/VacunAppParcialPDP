object calendarioHoy{
  method hoy() = new Date()
}

class Persona{
  var property nombre
  var property edad
  var property calendario = calendarioHoy
  var property provincia = "Buenos Aires"
  const provinciasEspeciales = ["Tierra del Fuego", "Santa Cruz", "Neuquén"]
  var property preferenciaVacuna = cualquierosa
  const historialDeVacunas = []

  var property inmunidad //es una fecha
  var property anticuerpos 

  method nombrePar() = nombre.length().even() 

  method elige(vacuna) = preferenciaVacuna.elige(vacuna, self)
  method esEspecial() = provinciasEspeciales.contains(provincia)

  method personaAux() = new Persona( //se crea para
    nombre = nombre,
    edad = edad,
    inmunidad = inmunidad,
    anticuerpos = anticuerpos,
    calendario = calendario
  )

  method multiplicarAnticuerpos(multiplicador) {
    anticuerpos = anticuerpos * multiplicador
  }

  method aumentarAnticuerpos(_anticuerpos) {
    anticuerpos += _anticuerpos
  }

  method darMesesInmunidad(meses){
    const fechaInmunidad = calendario.hoy().plusMonths(meses) 
    inmunidad = fechaInmunidad
  } 

  method eligeLaMasBarata(vacunas){
    return self.costoDeVacunas(vacunas).minIfEmpty(0)
  }
  
  method costoDeVacunas(vacunas) = self.vacunasQueElige(vacunas).map{vacuna => vacuna.costo(self)}
  method vacunasQueElige(vacunas) = vacunas.filter{vacuna => self.elige(vacuna)}

  method agregarVacunaHistoral(vacuna){
    historialDeVacunas.add(vacuna)
  }
}

class Vacuna{
  method aplicar(persona){
    self.validarAplicacion(persona)
    self.aumentarAnticuerpos(persona)
    self.otorgarInmunidad(persona)
    persona.agregarVacunaHistoral(self)
  }

  method validarAplicacion(persona){
    if(!persona.elige(self)) throw new DomainException(message = "La vacuna solicitada no es aplicable para la persona")
  }

  method aumentarAnticuerpos(persona)
  method otorgarInmunidad(persona)

  method costo(persona) = self.costoDeVacuna(persona) + self.costoParticular(persona)

  method costoDeVacuna(persona) = 1000 + 50 * self.aniosMasDe30(persona)
  method aniosMasDe30(persona) = (persona.edad() - 30).max(0)

  method costoParticular(persona)
}

object paifer inherits Vacuna{

  override method aumentarAnticuerpos(persona){
    persona.multiplicarAnticuerpos(10)
  } 
  
  override method otorgarInmunidad(persona){
    const meses = if (persona.edad() > 40) 6 else 9
    persona.darMesesInmunidad(meses)
  }

  override method costoParticular(persona) = if(persona.edad() < 18) 400 else 100
}

class Larussa inherits Vacuna{
  const multiplicador

  override method aumentarAnticuerpos(persona) {
    persona.multiplicarAnticuerpos(multiplicador.min(20))
  }

  override method otorgarInmunidad(persona) {
    const fechaInmunidad = new Date(day = 03, month = 03, year = 2024)
    persona.inmunidad(fechaInmunidad)
  }
  override method costoParticular(persona) = 100 * multiplicador.min(20)
}

object astraLaVistaZeneca inherits Vacuna{
  override method otorgarInmunidad(persona){
    const meses = if (persona.nombrePar()) 6 else 7
    persona.darMesesInmunidad(meses)
  }

  override method aumentarAnticuerpos(persona){
    persona.aumentarAnticuerpos(10000)
  }

  override method costoParticular(persona) = if(persona.esEspecial()) 2000 else 0
}

class Combineta inherits Vacuna{
  const vacunas = []

  override method otorgarInmunidad(persona){
    const _inmunidad = self.mayorInmunidad(persona)
    persona.inmunidad(_inmunidad)
  } 

  override method aumentarAnticuerpos(persona){
    const _anticuerpos = self.menorAnticuerpos(persona)
    persona.anticuerpos(_anticuerpos)
  }

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


//Punto 4
const larussa2 = new Larussa(multiplicador = 2)
const larussa5 = new Larussa(multiplicador = 5)
const combineta = new Combineta(vacunas = [larussa2, paifer])

object planDeVacunacion{
  const listaDePersonas = []
  const listaDeVacunas = [paifer, larussa2, larussa5, astraLaVistaZeneca, combineta]

  method costoTotal() = self.costosPorVacunas().sum()

  method costosPorVacunas() = listaDePersonas.map{persona => persona.eligeLaMasBarata(listaDeVacunas)}
}

//Punto 5


