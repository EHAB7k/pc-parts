//
//  HomeViewController.swift
//  BP
//
//  Created by Ehab Hakami on 20/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {
    var newPieceArr = [NewPeice]()
    var selectedNewPieceModel:NewPeice?
    var selectedNewPieceImage:UIImage?
    
    
    @IBOutlet weak var pieceTableView: UITableView!
    
        

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieceTableView.delegate = self
        pieceTableView.dataSource = self
       
        
        getPosts()
        // Do any additional setup after loading the view.
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
                                        self.pieceTableView.reloadData()
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
                                self.pieceTableView.reloadData()
                            }
                        }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.newPieceArr.firstIndex(where: {$0.id == postId}){
                            self.newPieceArr.remove(at: deleteIndex)
                            DispatchQueue.main.async {
                                self.pieceTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }//end func
    
    @IBAction func handleLogOut(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } catch  {
            print("ERROR in signout",error.localizedDescription)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toPostVC" {
                let vc = segue.destination as! AddNewPieceViewController
                vc.selectedNewPiece = selectedNewPieceModel
                vc.selectedNewPieceImage = selectedNewPieceImage
            }else {
                
               let vc = segue.destination as! DetailsViewController
                vc.selectedNewPiece = selectedNewPieceModel
                vc.selectedNewPieceImage = selectedNewPieceImage
            }
        }
     
    }
    
    
    
    
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPieceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewPieceCell
        
        
        
        return cell.configure(with: newPieceArr[indexPath.row])
    }
    
    
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/6
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewPieceCell
        selectedNewPieceImage = cell.newPieceImageView.image
        selectedNewPieceModel = newPieceArr[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == newPieceArr[indexPath.row].user.id{
          performSegue(withIdentifier: "toPostVC", sender: self)
        }else {
            performSegue(withIdentifier: "toDetailsVC", sender: self)
            
        }
    }
}
