
import UIKit
import LiquidCore

class ViewController: UIViewController, LCMicroServiceDelegate, LCMicroServiceEventListener {
    
    let responseEvent = "responseEvent";
    let readyEvent = "ready";
    let requestEvent = "requestEvent";

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnCall(){
        let jsURL = self.getURL()
        let service = LCMicroService(url: jsURL, delegate: self)
        service?.start()
        
    }
    
    func onEvent(_ service: LCMicroService, event: String, payload: Any?) {
        
        if event == readyEvent {
            print("Ready Event triggered")
            let requestObject = self.getRequestObject();
            service.emitString(requestEvent, string: requestObject)
        }
        else if event == responseEvent {
            
            DispatchQueue.main.async {
                print("Data Received from JS : ", payload!);
                let responseObj = (payload as! Dictionary<String,AnyObject>)
                
                let sortedNum = responseObj["sortedArray"].unsafelyUnwrapped as! NSArray
                self.showAlert(message: sortedNum.description )
            }

        }
    }
    
    
    func onStart(_ service: LCMicroService) {
        service.addEventListener(self.readyEvent, listener: self)
        service.addEventListener(self.responseEvent, listener: self)
    }
    
    func getURL() -> URL{
        let jsFilePath = Bundle.main.path(forResource: "liquid", ofType: "bundle")
        let jsURL = URL.init(fileURLWithPath : jsFilePath.unsafelyUnwrapped)
        return jsURL
    }
    
    func getRequestObject() -> String{
        var theJSONText : String!
        let path = Bundle.main.path(forResource: "sampleObject", ofType: "json")
        let fileURL = URL.init(fileURLWithPath : path.unsafelyUnwrapped)
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            theJSONText=text2
        }
        catch let error as NSError {/* error handling here */
            print("CAUGHT ERROR - \(error)")
        }
        
        return theJSONText
    }
    
    func showAlert(message : String) -> Void {
        // ALERT CODE -
        
        let alert = UIAlertController(title: "Success!!", message: "\nResponse - \(message)", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "OK!", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true)

    }

}

