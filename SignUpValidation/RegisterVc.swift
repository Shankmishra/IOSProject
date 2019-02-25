
import UIKit
import SkyFloatingLabelTextField
import SKCountryPicker
import IQKeyboardManagerSwift
import CoreData
import GoogleMaps
import GooglePlaces
class RegisterVc: UIViewController{
    @IBOutlet weak var SubmitOutlet: UIButton!
    @IBOutlet weak var ControllerTitle: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var ButtonCountry: UIButton!
    @IBOutlet weak var LabelCountry: UILabel!
    @IBOutlet weak var FemaleRadio: UIButton!
    @IBOutlet weak var MaleRadio: UIButton!
    @IBOutlet weak var FemaleStack: UIStackView!
    @IBOutlet weak var MaleStack: UIStackView!
    @IBOutlet weak var ZipCode: SkyFloatingLabelTextField!
    @IBOutlet weak var State: SkyFloatingLabelTextField!
    @IBOutlet weak var City: SkyFloatingLabelTextField!
    @IBOutlet weak var Adress: SkyFloatingLabelTextField!
    @IBOutlet weak var Password: SkyFloatingLabelTextField!
    @IBOutlet weak var Email: SkyFloatingLabelTextField!
    @IBOutlet weak var MobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var LastName: SkyFloatingLabelTextField!
    @IBOutlet weak var FirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var ViewBack: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    var profileList: [NSManagedObject] = []
    var node: NSManagedObject?
    var check :Bool?
    var selectedDialingcode:String?
    var selectedGender:String = ""
    // MAp View Action
    var checkPassword = false
    var checkEmail = false
    @IBAction func MapViewAction(_ sender: Any) {
        if let vc :AddressViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController
        {
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
    
    
    @IBAction func BackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
  
    
    
    
    
    @IBAction func CountryButtonAction(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.flagImage.image = country.flag
            self.ButtonCountry.setTitle(country.dialingCode, for: .normal)
            self.selectedDialingcode = country.dialingCode
        }
        countryController.detailColor = UIColor.black
    }
    
    
 
    @IBAction func SaveProfileAction(_ sender: Any) {
        if check == true
        {
            editingToCore()
            
        }else
            
        {
            if (findingifExisting())
            {
                if( checkPassword == false || checkEmail == false)
                {
                    let alert = UIAlertController(title: "Status:", message: "Wrong Format", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else
                {
                savingToCore()
                }}
            else
            {
                let alert = UIAlertController(title: "Status:", message: "Email Id already taken", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    let contryPickerController = CountryPickerController()
   
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = #imageLiteral(resourceName: "icDone")
        imageView1.image = image1
        imageView1.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        
        let image2 = #imageLiteral(resourceName: "icDone")
        imageView2.image = image2
        imageView2.frame = CGRect(x: 0, y: 0, width: 20, height: 15)
        
        Email.rightViewMode = .always
        Email.delegate = self
        
        Password.rightViewMode = .whileEditing
        Password.delegate = self
        
        if (check == true)
        {
            ControllerTitle.text = "Edit Profile"
            SubmitOutlet.setTitle("Save Changes", for: .normal)
            setInitialValue()
        }
        
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width / 2
        self.ProfileImage.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        imagePic()
        let maletap1 = UITapGestureRecognizer(target: self, action: #selector(tapGesture2))
        MaleStack.addGestureRecognizer(maletap1)
        MaleStack.isUserInteractionEnabled = true
        
        
        let femaletap1 = UITapGestureRecognizer(target: self, action: #selector(tapGesture3))
        FemaleStack.addGestureRecognizer(femaletap1)
        FemaleStack.isUserInteractionEnabled = true
        
        
        let country = CountryManager.shared.currentCountry
        ButtonCountry.setTitle(country?.dialingCode, for: .normal)
        flagImage.image = country?.flag
        ButtonCountry.clipsToBounds = true
        
        
        MobileNumber.rightViewMode = .whileEditing
        MobileNumber.delegate = self
        
    }
}

// Image Picker

extension RegisterVc :  UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePic()
    {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapGesture1))
        ProfileImage.addGestureRecognizer(tap1)
        ProfileImage.isUserInteractionEnabled = true
    }
    @objc func tapGesture1() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let action = UIAlertController(title: "Select your Photo", message: "pick!", preferredStyle: .actionSheet)
        
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
                print("camera not working")
            }
        }))
        action.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(action, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]
        ProfileImage.image = (image as! UIImage)
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//Gender Action

extension RegisterVc
{
    @objc func tapGesture2() {
        selectedGender = "Male"
        MaleRadio.setImage(#imageLiteral(resourceName: "icRadioPressed"), for: .normal)
        FemaleRadio.setImage(#imageLiteral(resourceName: "icRadioNormal"), for: .normal)
    }
    
    @objc func tapGesture3() {
        selectedGender = "Female"
        FemaleRadio.setImage(#imageLiteral(resourceName: "icRadioPressed"), for: .normal)
        MaleRadio.setImage(#imageLiteral(resourceName: "icRadioNormal"), for: .normal)
    }
}


// Formatting email and password check

extension RegisterVc:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField
        {
        case MobileNumber:
            if let data = textField.text{
                if(data.count > 0)
                {
                    MobileNumber.text = formattedNumber(number: "\(MobileNumber.text!)")
                }else
                {
                    MobileNumber.rightView = UIView()
                }
            }
        case Email:
            if let data = textField.text{
                if(data.count > 0 && data.validEmail)
                {
                    Email.rightView = self.imageView1
                    checkEmail = true
                }else
                {
                    Email.rightView = UIView()
                    checkEmail = false
                }
            }
            if ((Email.text?.count)! > 60 && range.length == 0)
            {
                return false
            }
        case Password:
            if let data = textField.text{
                if(data.count > 0 && data.validPassword == true)
                {
                    Password.rightView = self.imageView2
                    checkPassword = true
                }else
                {
                    Password.rightView = UIView()
                    checkPassword = false
                }
            }
            if ((Password.text?.count)! > 14 && range.length == 0)
            {
                return false
            }
        default:
            print("NONE")
            
        }
        return true
        
    }
    
    // Mobile number formatter
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXX-XXX-XXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: (index))
            } else {
                result.append(ch)
            }
        }
        return result
    }
}



extension RegisterVc
{
    
   // Saving to core data
    
    func savingToCore()
    {
        if(FirstName.text != "" && LastName.text != "" && MobileNumber.text != "" && Email.text != "" && Password.text != "" && Adress.text != "" && City.text != "" && State.text != "" && ZipCode.text != "")
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newUser = NSEntityDescription.insertNewObject(forEntityName :"Profile", into :context)
            newUser.setValue(Adress.text, forKey: "address")
            newUser.setValue(City.text, forKey: "city")
            newUser.setValue(Email.text, forKey: "email")
            newUser.setValue(FirstName.text, forKey: "firstname")
            newUser.setValue(LastName.text, forKey: "lastname")
            newUser.setValue(MobileNumber.text, forKey: "mobilenumber")
            newUser.setValue(Password.text, forKey: "password")
            newUser.setValue(State.text, forKey: "state")
            newUser.setValue(ZipCode.text, forKey: "zipcode")
            newUser.setValue(ProfileImage.image, forKey: "proimg")
            newUser.setValue(selectedDialingcode, forKey: "phonecountry")
            newUser.setValue(selectedGender, forKey: "gender")
            newUser.setValue(flagImage.image!.pngData() as NSData?, forKey: "flagcountry")
            
            
            do
            {
                try context.save()
                print("Saved")
                let alert = UIAlertController(title: "Status:", message: "Success", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            catch
            {
                print("ERROR")
            }
        }
    }
    
   // Editing in coreData
    
    func editingToCore()
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        node!.setValue(Adress.text, forKey: "address")
        node!.setValue(City.text, forKey: "city")
        node!.setValue(Email.text, forKey: "email")
        node!.setValue(FirstName.text, forKey: "firstname")
        node!.setValue(LastName.text, forKey: "lastname")
        node!.setValue(MobileNumber.text, forKey: "mobilenumber")
        node!.setValue(Password.text, forKey: "password")
        node!.setValue(State.text, forKey: "state")
        node!.setValue(ZipCode.text, forKey: "zipcode")
        node!.setValue(ProfileImage.image, forKey: "proimg")
        node!.setValue(selectedDialingcode, forKey: "phonecountry")
        node!.setValue(selectedGender, forKey: "gender")
        node!.setValue(flagImage.image!.pngData() as NSData?, forKey: "flagcountry")
        do
        {
            try context.save()
            print("Saved")
            let alert = UIAlertController(title: "Status:", message: "Success", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        catch
        {
            print("ERROR")
        }
        
    }
}



//  initializing value to Form Fieldss

extension RegisterVc
{
    func setInitialValue()
    {
        Adress.text = (node!.value(forKey: "address") as! String)
        City.text = (node!.value(forKey: "city") as! String)
        Email.text = (node!.value(forKey: "email") as! String)
        FirstName.text = (node!.value(forKey: "firstname") as! String)
        LastName.text = (node!.value(forKey: "lastname") as! String)
        MobileNumber.text = (node!.value(forKey: "mobilenumber") as! String)
        Password.text = (node!.value(forKey: "password") as! String)
        State.text = (node!.value(forKey: "state") as! String)
        ProfileImage.image = (node!.value(forKey: "proimg") as! UIImage)
        let img = (node!.value(forKey: "flagcountry") as! Data)
        flagImage.image = UIImage(data: img)
        
        // flagImage.image = (node!.value(forKey: "flagcountry") as! UIImage)
        //   ImageCountry.image = (node!.value(forKey: "flag") as! UIImage)
        print(node!.value(forKey: "flag") as Any)
        print(node!.value(forKey: "proimg") as Any)
        let gen = (node!.value(forKey: "gender") as! String)
        if(gen == "Male")
        {
            tapGesture2()
        }else
        {
            tapGesture3()
        }
        
        ZipCode.text = (node!.value(forKey: "zipcode") as! String)
        
        
    }
    
    
}

// Checking CoreData

extension RegisterVc
{
    
    func findingifExisting()->Bool
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        let predicate = NSPredicate(format: "email == %@",Email.text!)
        fetchRequest.predicate = predicate
        
        do {
            profileList = try context.fetch(fetchRequest) as! [NSManagedObject]
            print(profileList)
            
        } catch let error as NSError {
            print("could not fetch \(error)")
        }
        if(profileList == [])
        {
            return true
        }
        return false
    }
}
