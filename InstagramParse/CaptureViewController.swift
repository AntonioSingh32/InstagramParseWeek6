//
//  CaptureViewController.swift
//  InstagramParse
//
//  Created by Clark Kent on 3/6/16.
//  Copyright © 2016 Antonio Singh. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class CaptureViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var captureImage: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
        captureImage.addGestureRecognizer(tapGesture)
        captureImage.userInteractionEnabled = true


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            captureImage.image = editedImage
            
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    class Post: NSObject {
        class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
            // Create Parse object PFObject
            let post = PFObject(className: "Post")
            
            // Add relevant fields to the object
            post["media"] = getPFFileFromImage(image) // PFFile column type
            post["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
            post["caption"] = caption
            post["likesCount"] = 0
            post["commentsCount"] = 0
            
            // Save object (following function will save the object in Parse asynchronously)
            post.saveInBackgroundWithBlock(completion)
        }
        
        class func getPFFileFromImage(image: UIImage?) -> PFFile? {
            // check if image is not nil
            if let image = image {
                // get image data and check if that is not nil
                if let imageData = UIImagePNGRepresentation(image) {
                    return PFFile(name: "image.png", data: imageData)
                }
            }
            return nil
        }
    }

    @IBAction func onSubmitButton(sender: AnyObject) {
        
        if captureImage.image != nil || captionField.text != nil {
            
            Post.postUserImage(captureImage.image, withCaption: self.captionField.text, withCompletion: nil)
                print("Post successfully")
        }
            
        else {
            print("ERROR! No image and/or caption")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
