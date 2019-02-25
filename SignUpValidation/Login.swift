import UIKit
import SkyFloatingLabelTextField
import CoreData
class Login: UIViewController {
    @IBOutlet var Register: UIView!
    @IBOutlet weak var PasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var EmailIdField: SkyFloatingLabelTextField!
    @IBOutlet weak var demoImage: UIImageView!
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    var profileList: [NSManagedObject] = []
    
    //Action on Login Button
    
    @IBAction func LoginButton(_ sender: Any) {
        fetchNotes()
        guard EmailIdField.text != "" else {
            let alert = UIAlertController(title: "Status:", message: "Email Empty", preferredStyle:
                UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if profileList == []
        {
            let alert = UIAlertController(title: "Status:", message: "Wrong Email Id", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            guard PasswordField.text != "" else {
                let alert = UIAlertController(title: "Status:", message: "Password Empty", preferredStyle:
                    UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard PasswordField.text == (profileList[0].value(forKey: "password") as! String) else {
                let alert = UIAlertController(title: "Status:", message: "Wrong Password", preferredStyle:
                    UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let vc :RegisterVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVc") as? RegisterVc
            {
                EmailIdField.text = ""
                PasswordField.text = ""
                vc.node = profileList[0]
                vc.check = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
// Action on register Button
    
    @IBAction func RegisterAction(_ sender: Any) {
        if let vc :RegisterVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVc") as? RegisterVc
        {
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    // For Format validation
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image1 = #imageLiteral(resourceName: "icDone")
        imageView1.image = image1
        imageView1.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        let image2 = #imageLiteral(resourceName: "icDone")
        imageView2.image = image2
        imageView2.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        
        
        EmailIdField.rightViewMode = .always
        EmailIdField.delegate = self
        PasswordField.rightViewMode = .whileEditing
        PasswordField.delegate = self
    }}



// Formatting and maximum limit

extension Login :UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField
        {
        case EmailIdField:
            if let data = textField.text
            {
                if(data.count > 0 && data.validEmail == true )
                {
                    EmailIdField.rightView = self.imageView1
                    
                }else
                {
                    EmailIdField.rightView = UIView()
                    
                }
            }
            if (EmailIdField.text?.count)! > 60 && range.length == 0
            {
                return false
            }
        case PasswordField:
            if let data = PasswordField.text
            {
                if(data.count > 0 && data.validPassword == true )
                {
                    PasswordField.rightView = self.imageView2
                    
                }else
                {
                    PasswordField.rightView = UIView()
                    
                }
            }
            if (PasswordField.text?.count)! > 14 && range.length == 0
            {
                return false
            }
        default :
            print("None")
        }
        return true
    }}


// Regix For formatting

extension String
{
    var validEmail: Bool{
        let emailValidation = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailValidation)
        return emailTest.evaluate(with: self)
    }
    var validPassword: Bool{
        let passwordValidation = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*[A-Z])(?=.*[!@#$%&*?])[A-Za-z\\d$@$#!%*?&]{6,16}")
        return passwordValidation.evaluate(with: self)
    }
}

// Core data Check

extension Login
{
    func fetchNotes()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        let predicate = NSPredicate(format: "email == %@", EmailIdField.text!)
        fetchRequest.predicate = predicate
        
        do {
            profileList = try context.fetch(fetchRequest) as! [NSManagedObject]
            print("sdc")
            print(profileList)
            
        } catch let error as NSError {
            print("could not fetch \(error)")
        }
        
    }
}
