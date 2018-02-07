
import Foundation

protocol HomeModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {
    
    weak var delegate: HomeModelProtocol!
    let urlPath = "http://iesayala.ddns.net/nathan/select.php"
//    let urlPath = "http://192.168.1.200/nathan/select.php"
    
    func obtenerDatos() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Fallo al descargar datos")
            }else {
                print("Datos descargados")
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
    }
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0 ..< jsonResult.count {
            
            jsonElement = jsonResult[i] as! NSDictionary
            let location = LocationModel()
            
            if let cod = jsonElement["nNumEvento"] as? String,
                let titulo = jsonElement["cTitEvento"] as? String,
                let desc = jsonElement["cDescEvento"] as? String,
                let fecha = jsonElement["cFecEvento"] as? String {
                
                location.cod = cod
                location.titulo = titulo
                location.desc = desc
                location.fecha = fecha
                
            }
            
            locations.add(location)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: locations)
            
        })
    }
}
