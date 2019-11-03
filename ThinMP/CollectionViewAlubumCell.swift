import UIKit

class CollectionViewAlubumCell: UICollectionViewCell {
    @IBOutlet var artworkView: UIImageView!
    @IBOutlet var primaryText: UILabel!
    @IBOutlet var secondaryText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.artworkView.contentMode = UIView.ContentMode.scaleAspectFill
        self.artworkView.clipsToBounds = true
    }

}
