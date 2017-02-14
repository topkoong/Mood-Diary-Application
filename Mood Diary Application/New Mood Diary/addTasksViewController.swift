//
//  addTasksViewController.swift
//  New Mood Diary
//
//  Created by 胡远 on 2016/12/3.
//  Copyright © 2016年 Wentaile Wu. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
var address : String!

class addTasksViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var soundFileURL : NSURL!
    var URLString : String!
    @IBOutlet weak var imageHolder: UIImageView!

    @IBOutlet weak var itemContent: UITextView!
    @IBOutlet weak var itemTitle: UITextField!
    
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    
    @IBOutlet var addressTextField: UITextField!
    //Create new Diary
    @IBAction func add(_ sender: UIButton) {
       
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let item = Item(context:context)
        item.title = itemTitle.text
        item.content = itemContent.text
        item.image = UIImagePNGRepresentation(imageHolder.image!) as NSData?
        item.date = itemDate.text
        item.address = address
        //filteredItems.append(item.title!)
        item.audioURL = URLString
        address = ""
        // save data to core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //itemContent.text = "text"'
        var date: NSDate
        date = NSDate(timeIntervalSinceNow: 0.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        self.itemDate.text = dateFormatter.string(from: date as Date)
        itemContent.isEditable = true
        //itemContent.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        // Do any additional setup after loading the view.
        PlayButton.isEnabled = false
        StopButton.isEnabled = false
        imagePicker.delegate = self
        
 
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }

    }


    override func viewDidAppear(_ animated: Bool) {
        self.addressTextField.text = address
    }
    

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let imagePicker = UIImagePickerController()
    @IBAction func takePicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        present(imagePicker, animated:true, completion: nil)
    }
    
    @IBAction func dismissKeyboard() {
        itemTitle.resignFirstResponder()
        itemContent.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageHolder.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        soundFileURL = dirPaths[0].appendingPathComponent(itemTitle.text! + "1.caf") as NSURL!
        URLString = soundFileURL.path
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL as URL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        if audioRecorder?.isRecording == false {
            PlayButton.isEnabled = false
            StopButton.isEnabled = true
            audioRecorder?.record()
        }
    }

    @IBAction func stopAudio(_ sender: UIButton) {
        StopButton.isEnabled = false
        PlayButton.isEnabled = true
        RecordButton.isEnabled = true
       
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }

    }
    @IBAction func playAudio(_ sender: UIButton) {
        if audioRecorder?.isRecording == false {
            StopButton.isEnabled = true
            RecordButton.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        RecordButton.isEnabled = true
        StopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
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

