
import Foundation



class LocationModel: NSObject {
    
    // Definicion de variables
    var cod: String?
    var titulo: String?
    var desc: String?
    var fecha: String?
    
    //Constructor vacio
    override init(){}
    
    //Constructor con parametros
    init(cod: String, titulo: String, desc: String, fecha: String) {
        self.cod = cod
        self.titulo = titulo
        self.desc = desc
        self.fecha = fecha
    }
    
    //Imprimir objetos
    override var description: String {
        return "Numero: \(cod), Titulo: \(titulo), Descripcion: \(desc), Fecha: \(fecha)"
    }
    
    
}
