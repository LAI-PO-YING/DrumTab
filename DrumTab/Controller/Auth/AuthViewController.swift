//
//  AuthViewController.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/11/2.
//

import UIKit
import AuthenticationServices
import FirebaseAuth
import CryptoKit
import AVKit
import SafariServices

class AuthViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var signInWithAppleButtonView: UIView!
    
    let firebase = FirebaseFirestoreManager.shared
    fileprivate var currentNonce: String?
    let videoPlayerLooped = VideoPlayerLooped()
    
    @objc func pressSignInWithAppleButton() {
        let authorizationAppleIDRequest: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        authorizationAppleIDRequest.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        authorizationAppleIDRequest.nonce = sha256(nonce)
        currentNonce = nonce
        
        let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [authorizationAppleIDRequest])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }

    override func viewDidLayoutSubviews() {
        videoPlayerLooped.playVideo(fileName: "intro", inView: videoView)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let authorizationAppleIDButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        authorizationAppleIDButton.addTarget(
            self,
            action: #selector(pressSignInWithAppleButton),
            for: UIControl.Event.touchUpInside
        )
        authorizationAppleIDButton.frame = self.signInWithAppleButtonView.bounds
        authorizationAppleIDButton.cornerRadius = 10
        self.signInWithAppleButtonView.addSubview(authorizationAppleIDButton)
        signInWithAppleButtonView.backgroundColor = .clear
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://www.privacypolicies.com/live/897a9283-8d29-46f8-a47b-5a5031f98f46") else { return }
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
    @IBAction func eulaButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://www.eulatemplate.com/live.php?token=11bWFaoN2h6Xd3HBWiWmvVzh3FSXbDUz") else { return }
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
    
    
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    /// 授權成功
    /// - Parameters:
    ///   - controller: _
    ///   - authorization: _
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let currentUser = authResult?.user{
                    self.firebase.checkUserSignInBefore(uid: currentUser.uid) { result in
                        switch result {
                        case .success(let user):
                            if user == nil {
                                let givenName = appleIDCredential.fullName?.givenName ?? ""
                                let familyName = appleIDCredential.fullName?.familyName ?? ""
                                let email = appleIDCredential.email ?? ""
                                self.firebase.createUser(
                                    uid: currentUser.uid,
                                    userName: "\(givenName) \(familyName)",
                                    userEmail: email
                                ) {
                                    LocalUserData.userId = currentUser.uid
                                    self.firebase.fetchSpecificUser(userId: LocalUserData.userId) { user in
                                        LocalUserData.user = user
                                        let mainPageVC = UIStoryboard.main.instantiateViewController(withIdentifier:
                                            String(describing: DTTabBarViewController.self)
                                        )

                                        guard let mainPageVC = mainPageVC as? DTTabBarViewController else { return }

                                        self.show(mainPageVC, sender: nil)
                                    }
                                }
                            } else {
                                LocalUserData.userId = currentUser.uid
                                self.firebase.fetchSpecificUser(userId: LocalUserData.userId) { user in
                                    LocalUserData.user = user
                                    let mainPageVC = UIStoryboard.main.instantiateViewController(withIdentifier:
                                        String(describing: DTTabBarViewController.self)
                                    )

                                    guard let mainPageVC = mainPageVC as? DTTabBarViewController else { return }

                                    self.show(mainPageVC, sender: nil)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    /// 授權失敗
    /// - Parameters:
    ///   - controller: _
    ///   - error: _
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        switch (error) {
        case ASAuthorizationError.canceled:
            break
        case ASAuthorizationError.failed:
            break
        case ASAuthorizationError.invalidResponse:
            break
        case ASAuthorizationError.notHandled:
            break
        case ASAuthorizationError.unknown:
            break
        default:
            break
        }
        
        print("didCompleteWithError: \(error.localizedDescription)")
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    
    /// - Parameter controller: _
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

class VideoPlayerLooped {

    public var videoPlayer:AVQueuePlayer?
    public var videoPlayerLayer:AVPlayerLayer?
    var playerLooper: NSObject?
    var queuePlayer: AVQueuePlayer?

    func playVideo(fileName:String, inView:UIView){

        if let path = Bundle.main.path(forResource: fileName, ofType: "mp4") {

            let url = URL(fileURLWithPath: path)
            let playerItem = AVPlayerItem(url: url as URL)

            videoPlayer = AVQueuePlayer(items: [playerItem])
            playerLooper = AVPlayerLooper(player: videoPlayer!, templateItem: playerItem)

            videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
            videoPlayerLayer!.frame = inView.bounds
            videoPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill

            inView.layer.addSublayer(videoPlayerLayer!)

            videoPlayer?.play()
        }
    }

    func remove() {
        videoPlayerLayer?.removeFromSuperlayer()

    }
}
