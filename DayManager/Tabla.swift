

import UIKit

class Tabla: UITableViewCell {

    @IBOutlet weak var lbNum: UILabel!
    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
