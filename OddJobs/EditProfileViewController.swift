//
//  EditProfileViewController.swift
//  OddJobs
//
//  Created by Melody Ann Seda Marotte on 7/13/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVFoundation

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let user = PFUser.current()
    
    var cameraRollBool: Bool = false
    var isChangingBanner: Bool = true
    var myBannerImage: UIImage!
    var myProfileImage: UIImage!
    
    var profilePicChanged: Bool = false
    var bannerPicChanger: Bool = false
    
    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        usernameTextField.text = user?.username
        if let bio = user?["bio"] {
            bioTextField.text = bio as! String
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //verify for things that havent been changed or filled in
        if let name = usernameTextField.text {
            user?.username = name       //note this is what u sign in with so be careful 4 now
        }
        if let bio = bioTextField.text {
            user?["bio"] = bio
        }
        if profilePicChanged {
            user?["profilePicture"] = getPFFileFromImage(image: profilePictureImageView.image)
        }
        if bannerPicChanger {
            user?["backgroundImage"] = getPFFileFromImage(image: backgroundProfileImageView.image)
        }
        
        user?.saveInBackground()
        dismiss(animated: true, completion: nil)
    }
    
    func selectPic(){
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
        if (cameraAvailable) { //&& cameraRollBool
            print("Camera is available 📸 and willing to be used")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if (isChangingBanner) {
            myBannerImage = originalImage
            myBannerImage = editedImage
        } else {
            myProfileImage = originalImage
            myProfileImage = editedImage
        }
        print("finished setting image")
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    
    //for visual maybe make a button that is OVER the image to give the illusion of taping the pic to change it
    @IBAction func editProfilePictureButtonPressed(_ sender: Any) {
        isChangingBanner = false
        selectPic()
        if (myProfileImage) != nil {
            print("resizing image")
            myProfileImage = resizeImage(image: myProfileImage, targetSize: CGSize(width: 50, height: 50))
            profilePictureImageView.image = myProfileImage
            print("ProfilePic was set")
            profilePicChanged = true
        }
    }
    
    @IBAction func editBannerPictureButtonPressed(_ sender: Any) {
        isChangingBanner = true
        selectPic()
        if (myBannerImage) != nil {
            print("resizing image")
            myBannerImage = resizeImage(image: myBannerImage, targetSize: CGSize(width: 375, height: 100))
            backgroundProfileImageView.image = myBannerImage
            print("Banner was set")
            bannerPicChanger = true
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        // This is the rect that we've calculated out and this is what is actually used below
        let targetRect = CGRect(origin: CGPoint.zero, size: targetSize)
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: targetRect)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsGetCurrentContext()?.interpolationQuality = .high
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
