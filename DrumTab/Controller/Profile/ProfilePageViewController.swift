//
//  ProfilePageViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import UIKit
import Lottie
import FirebaseAuth
import SafariServices
import Kingfisher

class ProfilePageViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personalPhotoImageView: UIImageView!
    @IBOutlet weak var rankContainerView: UIView!

    @IBOutlet weak var firstPrizeView: UIView!
    @IBOutlet weak var firstPrizeImageView: UIImageView!
    @IBOutlet weak var firstPrizeNameLabel: UILabel!
    @IBOutlet weak var firstPrizeSinceLabel: UILabel!
    @IBOutlet weak var firstPrizeLikeLabel: UILabel!
    
    @IBOutlet weak var secondPrizeView: UIView!
    @IBOutlet weak var secondPrizeImageView: UIImageView!
    @IBOutlet weak var secondPrizeNameLabel: UILabel!
    @IBOutlet weak var secondPrizeSinceLabel: UILabel!
    @IBOutlet weak var secondPrizeLikeLabel: UILabel!

    @IBOutlet weak var thirdPrizeView: UIView!
    @IBOutlet weak var thirdPrizeImageView: UIImageView!
    @IBOutlet weak var thirdPrizeNameLabel: UILabel!
    @IBOutlet weak var thirdPrizeSinceLabel: UILabel!
    @IBOutlet weak var thirdPrizeLikeLabel: UILabel!
    
    
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    let firebase = FirebaseFirestoreManager.shared
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var creationView: UIView!
    @IBOutlet weak var followerView: UIView!
    @IBOutlet weak var likesView: UIView!

    @IBOutlet weak var creationValueLabel: UILabel!
    @IBOutlet weak var followerValueLabel: UILabel!
    @IBOutlet weak var likeValueLabel: UILabel!

    func importRankingViewData(users: [User]) {
        func transformDate(time: TimeInterval) -> String {
            let date = Date(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let returnStr = "Since \(dateFormatter.string(from: date))"
            return returnStr
        }
        firstPrizeImageView.kf.setImage(
            with: URL(string: users[0].userPhoto),
            placeholder: UIImage(systemName: "person.circle.fill")
        )
        firstPrizeNameLabel.text = "1. " + users[0].userName
        firstPrizeLikeLabel.text = "\(users[0].likesCount)"
        firstPrizeSinceLabel.text = transformDate(time: users[0].createdTime)

        secondPrizeImageView.kf.setImage(
            with: URL(string: users[1].userPhoto),
            placeholder: UIImage(systemName: "person.circle.fill")
        )
        secondPrizeNameLabel.text = "2. " + users[1].userName
        secondPrizeLikeLabel.text = "\(users[1].likesCount)"
        secondPrizeSinceLabel.text = transformDate(time: users[1].createdTime)

        thirdPrizeImageView.kf.setImage(
            with: URL(string: users[2].userPhoto),
            placeholder: UIImage(systemName: "person.circle.fill")
        )
        thirdPrizeNameLabel.text = "3. " + users[2].userName
        thirdPrizeLikeLabel.text = "\(users[2].likesCount)"
        thirdPrizeSinceLabel.text = transformDate(time: users[2].createdTime)

    }
    
    override func viewDidLayoutSubviews() {
        firstPrizeImageView.layer.cornerRadius = firstPrizeImageView.frame.height / 2
        secondPrizeImageView.layer.cornerRadius = secondPrizeImageView.frame.height / 2
        thirdPrizeImageView.layer.cornerRadius = thirdPrizeImageView.frame.height / 2
    }
    override func viewWillAppear(_ animated: Bool) {
        firebase.getRankInfo { users in
            self.importRankingViewData(users: users)
            
        }
        firebase.getPersonalCreation(userId: LocalUserData.userId) { result in
            switch result {
            case .success(let creations):
                print("creation: \(creations.count)")
                self.creationValueLabel.text = "\(creations.count)"
            case .failure(let error):
                print(error)
            }
        }
        firebase.getPersonalLikeValue(userId: LocalUserData.userId) { numberOfLikes in
            print("numberOfLikes: \(numberOfLikes)")
            self.likeValueLabel.text = "\(numberOfLikes)"
        }
        firebase.getFollowers(userId: LocalUserData.userId) { numberOfFollowers in
            print("numberOfFollowers: \(numberOfFollowers)")
            self.followerValueLabel.text = "\(numberOfFollowers)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = LocalUserData.user else { return }
        nameLabel.text = user.userName
        aboutMeLabel.text = user.aboutMe
        let photoUrl = URL(string: user.userPhoto)
        personalPhotoImageView.kf.setImage(with: photoUrl, placeholder: UIImage(systemName: "person.circle.fill"))

        self.personalPhotoImageView.layer.cornerRadius = 50
        creationView.layer.borderColor = UIColor(named: "D2")?.cgColor
        creationView.layer.borderWidth = 1
        followerView.layer.borderColor = UIColor(named: "D2")?.cgColor
        followerView.layer.borderWidth = 1
        likesView.layer.borderColor = UIColor(named: "D2")?.cgColor
        likesView.layer.borderWidth = 1

        
    }
    
    @IBAction func imageViewTap(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        let alert = UIAlertController(title: "Choose the photo from", message: nil, preferredStyle: .actionSheet)
        let showLibraryAction = UIAlertAction(title: "Album", style: .default) { _ in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true)
        }
        let showCameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let actions: [UIAlertAction] = [
            showLibraryAction,
            showCameraAction,
            cancelAction
        ]
        for action in actions {
            alert.addAction(action)
        }
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            
        }
        
        present(alert, animated: true, completion: nil)
    }
    @IBAction func nameLabelPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Update user name",
            message: "Please enter your name.", preferredStyle: .alert
        )
        controller.addTextField { textField in
            textField.placeholder = "User name"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned controller] _ in
            if let name = controller.textFields?[0].text {
                self.firebase.updateUserName(name: name)
                self.nameLabel.text = name
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func aboutMeLabelPressed(_ sender: Any) {
        let controller = UIAlertController(
            title: "Update about me",
            message: "Please enter your introduction.", preferredStyle: .alert
        )
        controller.addTextField { textField in
            textField.placeholder = "About me"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned controller] _ in
            if let aboutMe = controller.textFields?[0].text {
                self.firebase.updateUserAboutMe(aboutMe: aboutMe)
                self.aboutMeLabel.text = aboutMe
            }
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    @IBAction func settingButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Setting", message: nil, preferredStyle: .actionSheet)
        let privacyAction = UIAlertAction(title: "Privacy policy", style: .default) { _ in
            guard let url = URL(string: "https://www.privacypolicies.com/live/897a9283-8d29-46f8-a47b-5a5031f98f46") else { return }
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }
        let logoutAction = UIAlertAction(title: "Log out", style: .default) { _ in
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let authNavController = storyboard.instantiateViewController(identifier: "AuthViewController")
                
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authNavController)
                print("logoutButtonPressed")
            } catch {
                print("Fail")
            }
        }
        let deleteAction = UIAlertAction(title: "Delete account", style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: "Delete account", message: "Please contact developer: 229705jack@gmail.com to delete account.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            deleteAlert.addAction(deleteAction)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let actions: [UIAlertAction] = [
            privacyAction,
            logoutAction,
            deleteAction,
            cancelAction
        ]
        for action in actions {
            alert.addAction(action)
        }

        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
            
        }

        present(alert, animated: true, completion: nil)
    }
    
}
extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else { return }
        personalPhotoImageView.image = image
        firebase.uploadPhoto(image: image)
        dismiss(animated: true, completion: nil)
    }
}
