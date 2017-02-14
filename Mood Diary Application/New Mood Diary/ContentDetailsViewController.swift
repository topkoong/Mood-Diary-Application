//
//  ContentDetailsViewController.swift
//  New Mood Diary
//
//  Created by 胡远 on 2016/12/3.
//  Copyright © 2016年 Wentaile Wu. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Social

class ContentDetailsViewController: UIViewController, AVAudioPlayerDelegate {
    var item: Item? = nil
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var itemContent: UITextView!
    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet var itemAddress: UILabel!

    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBAction func shareTweet(_ sender: AnyObject) {
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)) {
            let shareToTweeter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            shareToTweeter?.setInitialText(item?.content)
            shareToTweeter?.add(itemImage.image)
            self.present(shareToTweeter!, animated: true, completion: nil)
        }
    }
    @IBAction func shareFb(_ sender: AnyObject) {
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)) {
            let shareToFacebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            shareToFacebook?.setInitialText(item?.content)
            shareToFacebook?.add(itemImage.image)
            self.present(shareToFacebook!, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayButton.isEnabled = false
        itemTitle.text = item?.title
        itemContent.text = item?.content
        itemDate.text = item?.date
        itemAddress.text = item?.address
        
        if let imageCheck = item?.image {
            itemImage.image = UIImage(data: imageCheck as Data)
        } else {
            print("Default image")
        }
        if (item?.audioURL) != nil{
           PlayButton.isEnabled = true
        } else{
           print("no audio")
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }

        
        //itemContent.isEditable = false
       // itemContent.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        
        // Do any additional setup after loading the view.
    }

    //@IBAction func EditContent(_ sender: Any) {
    
  //  }
    
    @IBAction func PlayAudio(_ sender: UIButton) {
        do {
            let urlStr : NSURL = NSURL(string:(item?.audioURL)!)!
            try audioPlayer = AVAudioPlayer(contentsOf:
                (urlStr) as URL)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Edit" {
            //let row = self.tableView.indexPathForSelectedRow?.row
            let editContentDetail = segue.destination as! EditContentViewController
            editContentDetail.item = item
            
            
            
            //itemController.item = item
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

}
