import UIKit

class TableViewTrackCell: UITableViewCell {

    @IBOutlet var artworkView: UIImageView!
    @IBOutlet var primaryText: UILabel!
    @IBOutlet var secondaryText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
