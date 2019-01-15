//
//  DetailViewController.swift
//  MVVMPractice
//
//  Created by Katherine Li on 1/10/19.
//  Copyright © 2019 Katherine Li. All rights reserved.
//

import UIKit

// MARK: - Detail View Controller

class DetailViewController: UIViewController {
    
    var messierViewModel: MessierViewModel?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.alpha = 0.0
        
        //#1 - Define a closure (completion block) INSTANCE for updating a UIImageView
        // once an image downloads.
        let imageCompletionClosure = { (imageData: NSData) -> Void in
            
            // #2 - Download occurs on background thread, but UI update MUST occur on the main thread.
            DispatchQueue.main.async {
                // #3 - Animate the appearance of the Messier image.
                UIView.animate(withDuration: 1.0, animations: {
                    self.imageView.alpha = 1.0
                    self.imageView.image = UIImage(data: imageData as Data)
                    self.view.setNeedsDisplay()
                })
                
                // #4 - Stop and hide the activity spinner as the image has finished downloading
                self.activitySpinner.stopAnimating()
            } // end DispatchQueue.main.async
        }
        
        // #5 - Start and show the activity spinner as the image is about to start downloading in background.
        activitySpinner.startAnimating()
        
        // #6 - Update the UI with info from the Messier object the user chose to inspect.
        titleLabel.text = messierViewModel?.formalName
        subtitleLabel.text = messierViewModel?.commonName
        updatedLabel.text = messierViewModel?.dateUpdated
        descriptionTextView.attributedText = messierViewModel?.textDescription
        
        // #7 - Start image downloading in background.
        messierViewModel?.download(completationHandler: imageCompletionClosure)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // #8 - make sure UITextView shows beginning of Messier object description
        self.descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
