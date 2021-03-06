//
// Created by Tristan Pollard on 2018-12-17.
// Copyright (c) 2018 Tristan Pollard. All rights reserved.
//

import UIKit

class MailItemViewController: UIViewController {

    var mailItem: EveMailItem!
    var mail: EveMail!

    var didDeleteMail: (() -> Void)?

    @IBOutlet weak var mailDescription: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mailDescription.isEditable = false

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(replyToMail)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteMail)),
        ]

        self.mailItem.fetchMail { item in
            self.mailDescription.text = item.getBodyString()
        }
    }

    @objc
    func replyToMail() {
        self.performSegue(withIdentifier: "mailItemToComposeMail", sender: self)
    }

    @objc
    func deleteMail() {
        self.mailItem.deleteMail { success in
            if success == true {
                self.didDeleteMail?()
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Failed to Delete Mail", message: "The mail was unable to be deleted. Perhaps it was already deleted?", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(action)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let sendMail = segue.destination as? SendMailViewController {
            sendMail.mail = self.mail
            sendMail.mailItem = self.mailItem
        }
    }

}

