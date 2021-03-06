//
//  DetailsViewController.swift
//  BP
//
//  Created by Ehab Hakami on 20/05/1443 AH.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var pieceInformation: UINavigationItem!{
        didSet{
            pieceInformation.title = "Piece information".localized
        }
    }
    var selectedNewPiece:NewPeice?
    var selectedNewPieceImage:UIImage?
    
    @IBOutlet weak var userNameLabel: UILabel!{
        didSet{
            userNameLabel.text = "User name".localized
        }
    }
    
    @IBOutlet weak var phoneNumber: UILabel!{
        didSet{
            phoneNumber.text = "Phone number".localized
        }
    }
    
    @IBOutlet weak var pieceImageView: UIImageView!
    
    @IBOutlet weak var thePieceName: UILabel!{
        didSet{
            thePieceName.text = "The piece name".localized
        }
    }
    
    @IBOutlet weak var thePriceOfThePieceLabel: UILabel!{
        didSet{
            thePriceOfThePieceLabel.text = "The price of the piece".localized
        }
    }
    
    @IBOutlet weak var ProductInformationTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedNewPiece = selectedNewPiece,
        let selectedNewPieceImage = selectedNewPieceImage{
            thePieceName.text = selectedNewPiece.title
            thePriceOfThePieceLabel.text = selectedNewPiece.description
            ProductInformationTextView.text = selectedNewPiece.productInformation
            pieceImageView.image = selectedNewPieceImage
            userNameLabel.text = selectedNewPiece.user.name
            phoneNumber.text = selectedNewPiece.phoneNumber

        // Do any additional setup after loading the view.
    }
        ProductInformationTextView.layer.borderColor = UIColor.systemGray.cgColor
        ProductInformationTextView.layer.borderWidth = 1.0
        ProductInformationTextView.layer.masksToBounds = true
        ProductInformationTextView.layer.cornerRadius = 7
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
