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

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    @IBOutlet weak var bagroundProfilePFImageView: PFImageView!
    @IBOutlet weak var profilePicturePFImageView: PFImageView!
    
    var cameraRollBool: Bool = false
    var isChangingBanner: Bool = true
    var myBannerImage: UIImage!
    var myProfileImage: UIImage!
    var profilePicChanged: Bool = false
    var bannerPicChanger: Bool = false
    var topCell: TopTableViewCell? = nil
    let user = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = user.username
        
        if let bio = user["bio"] {
            bioTextField.text = bio as! String
        }
        if user["profilePicture"] != nil {
            profilePicturePFImageView?.file = user["profilePicture"] as? PFFile
            profilePicturePFImageView?.loadInBackground()
        }
        if user["backgroundImage"] != nil {
            bagroundProfilePFImageView?.file = user["backgroundImage"] as? PFFile
            bagroundProfilePFImageView?.loadInBackground()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //verify for things that havent been changed or filled in
        if let name = usernameTextField.text {
            user.username = name       //note this is what u sign in with so be careful 4 now
        }
        if let bio = bioTextField.text {
            user["bio"] = bio
        }
        if profilePicChanged {
            user["profilePicture"] = profilePicturePFImageView.file
        }
        if bannerPicChanger {
            user["backgroundImage"] = bagroundProfilePFImageView.file
        }
        
        user.saveInBackground()
        
        if let topCell = topCell {
            topTableViewCell(topCell)
            print("in the top cell edit profile")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfilePictureButtonPressed(_ sender: Any) {
        isChangingBanner = false
        selectPic()
    }
    
    @IBAction func editBannerPictureButtonPressed(_ sender: Any) {
        isChangingBanner = true
        selectPic()
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPic() {
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
        present(vc, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if (isChangingBanner) {
            myBannerImage = originalImage
            myBannerImage = editedImage
            
            myBannerImage = resizeImage(image: myBannerImage, targetSize: CGSize(width: 375, height: 100))
            
            bagroundProfilePFImageView.file = Job.getPFFileFromImage(image: myBannerImage)
            bagroundProfilePFImageView.loadInBackground()
            
            print("Banner was set")
            bannerPicChanger = true
        } else {
            myProfileImage = originalImage
            myProfileImage = editedImage
            
            myProfileImage = resizeImage(image: myProfileImage, targetSize: CGSize(width: 50, height: 50))
            
            profilePicturePFImageView.file = Job.getPFFileFromImage(image: myProfileImage)
            profilePicturePFImageView.loadInBackground()
            
            print("ProfilePic was set")
            profilePicChanged = true
        }
        print("finished setting image")
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: TopTableViewDelegate {
    
    func topTableViewCell(_ topTableViewCell: TopTableViewCell) {
        topTableViewCell.loadData()
    }
    
}
