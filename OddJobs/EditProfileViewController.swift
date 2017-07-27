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
    @IBOutlet weak var skillLabel: UILabel!
    
    var cameraRollBool: Bool = false
    var isChangingBanner: Bool = true
    var myBannerImage: UIImage!
    var myProfileImage: UIImage!
    var profilePicChanged: Bool = false
    var bannerPicChanger: Bool = false
    var topCell: TopTableViewCell? = nil
    var tags: [String] = []
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
        
        let skills = user["skills"] as! [String]
        skillLabel.text = ""
        for (index, element) in skills.enumerated() {
            skillLabel.text = skillLabel.text! + element
            if (index < skills.count - 1) {
                skillLabel.text = skillLabel.text! + ", "
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tagsViewController = segue.destination as! TagsTableViewController
        tagsViewController.delegate = self
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
        
        print("tags holds")
        print(tags)
        user["skills"] = []
        var temp: [String] = []
        for skill in tags {
            temp.append(skill)
        }
        user["skills"] = temp
        print("temps var holds:")
        print(temp)
        print("user skills holds:")
        print(user["skills"])
        
        user.saveInBackground()
        
        if let topCell = topCell {
            topTableViewCell(topCell)
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
    
    @IBAction func didLogOut(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User logged out successfully")
                NotificationCenter.default.post(name: NSNotification.Name("logoutNotification"), object: nil)
            }
        }
    }
    
    @IBAction func editSkillsLabelButtonPressed(_ sender: Any) {
        print("edit skills button pressed")
        performSegue(withIdentifier: "chooseSkills", sender: nil)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectPic() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        let alert = UIAlertController(title: "Image Selection", message: "Do you wish to take a new photo or selecte an image from your camrea roll?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { action in
            print("user wishes to take a photo")
            let cameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
            if (cameraAvailable) {
                print("Camera is available 📸 and willing to be used")
                vc.sourceType = .camera
            } else {
                print("Camera 🚫 available so we will use photo library instead")
                vc.sourceType = .photoLibrary
            }
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: { action in
            print("user wishes to use the camera roll")
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
        
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

extension EditProfileViewController: TagsTableViewControllerDelegate {
    func createTags(tags: [String]) {
        print ("in create tags")
        self.tags = tags
    }
}
