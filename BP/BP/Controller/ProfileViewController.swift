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
    var newPieceArr = [NewPeice]()
    var userImage = ""
    
    
    var selectedNewPieceImage:UIImage?
    let activityIndicator = UIActivityIndicatorView()
    
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
    
    
    
    @IBOutlet weak var userPieceTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileData()
        getPosts()
        
        userPieceTableView.delegate = self
        userPieceTableView.dataSource = self
        
    }
    func getPosts() {
        let ref = Firestore.firestore()
        ref.collection("addPiece").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }
            if let snapshot = snapshot {
                snapshot.documentChanges.forEach { diff in
                    let post = diff.document.data()
                    switch diff.type {
                    case .added :
                        if let userId = post["userId"] as? String {
                            if let currentUser = Auth.auth().currentUser {
                                let currentUserId = currentUser.uid
                                if userId == currentUserId {
                                    ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                        if let error = error {
                                            print("ERROR user Data",error.localizedDescription)
                                            
                                        }
                                        if let userSnapshot = userSnapshot,
                                           let userData = userSnapshot.data(){
                                            let user = User(dict:userData)
                                            let post = NewPeice(dict:post,id:diff.document.documentID,user:user)
                                            self.newPieceArr.insert(post, at: 0)
                                            DispatchQueue.main.async {
                                                self.userPieceTableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    case .modified:
                        let postId = diff.document.documentID
                        if let currentPost = self.newPieceArr.first(where: {$0.id == postId}),
                           let updateIndex = self.newPieceArr.firstIndex(where: {$0.id == postId}){
                            let newPost = NewPeice(dict:post, id: postId, user: currentPost.user)
                            self.newPieceArr[updateIndex] = newPost
                            DispatchQueue.main.async {
                                self.userPieceTableView.reloadData()
                            }
                        }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.newPieceArr.firstIndex(where: {$0.id == postId}){
                            self.newPieceArr.remove(at: deleteIndex)
                            DispatchQueue.main.async {
                                self.userPieceTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }//end func
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
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toPostVC" {
                let vc = segue.destination as! AddNewPieceViewController
                vc.selectedNewPiece = selectedNewPiece
                vc.selectedNewPieceImage = selectedNewPieceImage
            }
        }
        
    }
    
    
    

    
    
    
    
}


extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPieceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath) as! NewPieceCell
        
        
        
        return cell.userConfigure(with: newPieceArr[indexPath.row])
    }
    
    
}
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewPieceCell
        selectedNewPieceImage = cell.UserPieceImage.image
        selectedNewPiece = newPieceArr[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == newPieceArr[indexPath.row].user.id{
            performSegue(withIdentifier: "toPostVC", sender: self)
        }
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let ref = Firestore.firestore().collection("addPiece")
            ref.document(self.newPieceArr[indexPath.row].id).delete(completion: { error in
                if let error = error {
                    print("Error in db delete",error)
                } else {
                    if self.newPieceArr.count > 0 {
                        let storageRef = Storage.storage().reference(withPath: "addPiece/\(self.newPieceArr[indexPath.row].user.id)/\(self.newPieceArr[indexPath.row].id)")
                        storageRef.delete { error in
                            if let error = error {
                                print("Error in storage delete",error)
                            } else {
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.userPieceTableView.reloadData()
                    }
                }
            })
            

        }
        return UISwipeActionsConfiguration(actions: [action])
        
    }
}

