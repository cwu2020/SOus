import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var timeStamp: UILabel!
    
    @IBOutlet var postTextView: UILabel!
   
    
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var freshness: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

    
