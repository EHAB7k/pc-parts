//
//  ProfileViewController.swift
//  BP
//
//  Created by Ehab Hakami on 21/05/1443 AH.
//

import UIKit
import Firebase
import Foundation
class ProfileViewController: UIViewController {
    var selectedNewPiece:NewPeice?
    
var userImage = ""
    @IBOutlet weak var profileUser: UIImageView!{
        didSet {
            profileUser.layer.borderColor = UIColor.systemGray.cgColor
                    profileUser.layer.borderWidth = 2.0
                    profileUser.layer.cornerRadius = profileUser.bounds.height / 2
                    profileUser.layer.masksToBounds = true
                    profileUser.isUserInteractionEnabled = true
                }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userBio: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
getProfileData()

        
    }
    

        func getProfileData(){
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore()
            .document("users/\(currentUserID)")
            .addSnapshotListener{ doucument, error in
                if error != nil {
                    print ("error",error!.localizedDescription)
                    return
                }

                self.userImage = (doucument?.data()?["imageUrl"] as? String)!
                self.userNameLabel.text = doucument?.data()?["name"] as? String
               // self.userBioLabel.text = doucument?.data()?["bio"] as? String

                var image:String
                image = self.userImage

                if let ImagemnueURl = URL(string:image )
                {

                    DispatchQueue.global().async {
                        if let ImageData = try? Data(contentsOf:ImagemnueURl) {
                            let Image = UIImage(data: ImageData)
                            DispatchQueue.main.async {
                                self.profileUser.image = Image

                            }
                        }
                    }

                }

            }
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

