//
//  TableViewCell.swift
//  BP
//
//  Created by Ehab Hakami on 20/05/1443 AH.
//

import UIKit

class NewPieceCell: UITableViewCell {

    @IBOutlet weak var newPieceImageView: UIImageView!
    
    @IBOutlet weak var newPieceTitleLabel: UILabel!
    
    @IBOutlet weak var newPieceDescriptionLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!{
        didSet {
            userImageView.layer.borderColor = UIColor.systemGray.cgColor
            userImageView.layer.borderWidth = 3.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            
            
        }
    }
    
    @IBOutlet weak var UserPieceImage: UIImageView!
    @IBOutlet weak var userPieceTitleLabel: UILabel!
    @IBOutlet weak var userPiecePriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with addPiece:NewPeice) -> UITableViewCell {
        newPieceTitleLabel.text = addPiece.title
        newPieceDescriptionLabel.text = addPiece.description
        newPieceImageView.loadImageUsingCache(with: addPiece.imageUrl)
       // userNameLabel.text = addPiece.user.name
        //userImageView.loadImageUsingCache(with: addPiece.user.imageUrl)
        return self
    }
    
    func userConfigure(with addPiece:NewPeice) -> UITableViewCell {
        userPieceTitleLabel.text = addPiece.title
        userPiecePriceLabel.text = addPiece.description
        UserPieceImage.loadImageUsingCache(with: addPiece.imageUrl)
       // userNameLabel.text = addPiece.user.name
        //userImageView.loadImageUsingCache(with: addPiece.user.imageUrl)
        return self
    }
    
    override func prepareForReuse() {
        //userImageView.image = nil
        newPieceImageView.image = nil
        UserPieceImage.image = nil
    }

}
