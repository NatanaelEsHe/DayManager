
import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var dpFecha: UIDatePicker!
    @IBOutlet weak var tfDesc: UITextField!
    @IBOutlet weak var tfTitulo: UITextField!
    var fecha: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        fecha = dateFormatter.string(from: Date())
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .right) {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btAgregar(_ sender: Any) {
        if(comprobarTF()){
            agregar(titulo: tfTitulo.text!, desc: tfDesc.text!, fec: fecha)
            self.view.endEditing(true)
        }        
    }
    
    @IBAction func dpChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        fecha = dateFormatter.string(from: sender.date)
    }
    
    func comprobarTF() -> Bool{
        if(tfTitulo.text!.isEmpty) {
            tfTitulo.becomeFirstResponder()
            let alert = UIAlertController(title: "¡Información!", message: "El título no puede estar vacío.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        if(tfDesc.text!.isEmpty) {
            tfTitulo.becomeFirstResponder()
            let alert = UIAlertController(title: "¡Información!", message: "La descripción no puede estar vacía.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func limpiar(){
        tfTitulo.text = ""
        tfDesc.text = ""
        dpFecha.date = Date()
    }
    
    func agregar(titulo: String, desc: String, fec: String){
        let request = NSMutableURLRequest(url: NSURL(string: "http://iesayala.ddns.net/nathan/insert.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(titulo)&b=\(desc)&c=\(fec)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            if error != nil {
                print("Error de conexión")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if ((responseString?.isEqual(to: "1")))! {
                print("Agregado")
            }
            else {
                print("Error al agregar")
            }
        }
        task.resume()
        self.limpiar()
        self.tabBarController?.selectedIndex = 0
    }
}
