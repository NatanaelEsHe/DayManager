

import UIKit

class EventosTableViewController: UITableViewController, HomeModelProtocol {
    
    var feedItems: NSMutableArray = NSMutableArray()
    var selectedLocation : LocationModel = LocationModel()
    var message : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        rellenarTabla()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rellenarTabla()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        rellenarTabla()
        tableView.reloadData();
        sender .endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItems.count
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items as! NSMutableArray
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "cell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath) as? Tabla else  {
            fatalError("La celda no esta instanciada en Tabla")
        }
        let item: LocationModel = feedItems[indexPath.row] as! LocationModel
        cell.lbTitulo.text = item.titulo
        cell.lbFecha.text = item.fecha
        cell.lbNum.text = item.cod
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let cell = tableView.cellForRow(at: indexPath) as? Tabla
            let cod = cell?.lbNum.text!
            eliminar(cod: cod!)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func eliminar(cod : String){
        let request = NSMutableURLRequest(url: NSURL(string: "http://iesayala.ddns.net/nathan/delete.php")! as URL)
        request.httpMethod = "POST"
        
        let postString = "a=\(cod)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            if error != nil {
                print("Error de conexión")
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if ((responseString?.isEqual(to: "1")))! {
                print("Eliminado")
                self.rellenarTabla()
            }
            else {
                print("Error al eliminar")
            }
        }
        task.resume()
    }
    
    func rellenarTabla(){
        let homeModel = HomeModel()
        homeModel.delegate = self
        homeModel.obtenerDatos()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
