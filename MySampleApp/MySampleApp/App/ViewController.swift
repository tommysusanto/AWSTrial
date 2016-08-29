//
//  ViewController.swift
//  Goconn
//
//  Created by Tommy Susanto on 28/08/2016.
//
//

import UIKit
import AWSMobileHubHelper
import FBSDKLoginKit


class ViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var anchorView: UIView!
    @IBOutlet weak var imageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook login permissions can be optionally set, but must be set
        // before user authenticates.
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
        
        // Facebook login behavior can be optionally set, but must be set
        // before user authenticates.
        //                AWSFacebookSignInProvider.sharedInstance().setLoginBehavior(FBSDKLoginBehavior.Web.rawValue)
        
        // Facebook UI Setup
        facebookButton.addTarget(self, action: #selector(ViewController.handleFacebookLogin), forControlEvents: .TouchUpInside)
        let facebookButtonImage: UIImage? = UIImage(named: "FacebookButton")
        if let facebookButtonImage = facebookButtonImage{
            facebookButton.setImage(facebookButtonImage, forState: .Normal)
        } else {
            print("Facebook button image unavailable. We're hiding this button.")
            facebookButton.hidden = true
        }
        
        let identityManager = AWSIdentityManager.defaultIdentityManager()
        
        if let identityUserName = identityManager.userName {
            print("Identity USERNAME : \(identityUserName)")
        } else {
            print("Guest")
        }
        
        print("Identity USEDID : \(identityManager.identityId)")
        if let imageURL = identityManager.imageURL {
            let imageData = NSData(contentsOfURL: imageURL)!
            if let profileImage = UIImage(data: imageData) {
                self.imageView.image = profileImage
            } else {
                //User Default Image
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utility Methods
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        AWSIdentityManager.defaultIdentityManager().loginWithSignInProvider(signInProvider, completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
            // If no error reported by SignInProvider, discard the sign-in view controller.
            if error == nil {
                dispatch_async(dispatch_get_main_queue(),{
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
//            print("result = \(result), error = \(error)")
        })
    }
    
    func showErrorDialog(loginProviderName: String, withError error: NSError) {
//        print("\(loginProviderName) failed to sign in w/ error: \(error)")
        let alertController = UIAlertController(title: NSLocalizedString("Sign-in Provider Sign-In Error", comment: "Sign-in error for sign-in failure."), message: NSLocalizedString("\(loginProviderName) failed to sign in w/ error: \(error)", comment: "Sign-in message structure for sign-in failure."), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Label to cancel sign-in failure."), style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    // MARK: - IBActions
    func handleFacebookLogin() {
        handleLoginWithSignInProvider(AWSFacebookSignInProvider.sharedInstance())
    }

}
