//
//  EditContentViewController.swift
//  New Mood Diary
//
//  Created by 胡远 on 2016/12/3.
//  Copyright © 2016年 Wentaile Wu. All rights reserved.
//

import UIKit
import CoreData

class EditContentViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var item : Item? = nil
    
    @IBOutlet weak var itemTitle: UITextField!
    
    @IBOutlet weak var itemContent: UITextView!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet var itemAddress: UILabel!
    
    @IBOutlet var itemDate: UILabel!
    @IBAction func SaveDiary(_ sender: UIButton) {
        //      item?.setValue(itemTitle.text, forKey: "title")
        //      item?.setValue(itemContent.text, forKey: "content")
        //      item?.setValue(itemImage.image, forKey: "image")
        item?.title = itemTitle.text
        item?.content = itemContent.text
        item?.image = UIImagePNGRepresentation(itemImage.image!) as NSData?
        // save data to core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTitle.text = item?.title
        itemContent.text = item?.content
        if let imageCheck = item?.image {
            itemImage.image = UIImage(data: imageCheck as Data)
        } else {
            print("Default image")
        }
        itemAddress.text = item?.address
        itemDate.text = item?.date
        
        itemContent.isEditable = true
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func takePhoto(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated:true, completion: nil)

    }
/*
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated:true, completion: nil)
    }
*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //itemImage.contentMode = .scaleAspectFit
            itemImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
