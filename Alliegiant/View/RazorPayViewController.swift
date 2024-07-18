////
////  RazorPayViewController.swift
////  Alliegiant
////
////  Created by P10 on 18/07/24.
////
//
//import UIKit
//import Razorpay
//
//class RazorPayViewController: UIViewController {
//    
//    let razorPayKey = "rzp_test_rpBn8AgkrcNdDH"
//    var razorPay : RazorpayCheckout? = nil
//    var merchantDetails: MerchantDetails = MerchantDetails.getDefaultData()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//    }
//    @IBAction func payTapped(_ sender: Any) {
//        openRazorPayCheckOut()
//    }
//    
//    func openRazorPayCheckOut(){
//        razorPay = RazorpayCheckout.initWithKey(razorPayKey, andDelegate: self)
//        let options: [String:Any] = [
////                    "key": razorPayKey,
//                    "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
//                    "currency": "INR",//We support more that 92 international currencies.
//                    "description": "Pay 100 Rupees Now",
////                    "order_id": "order_DBJOWzybf0sJbb",
//                    "image": merchantDetails.logo,
//                    "name": merchantDetails.name,
//                    "prefill": [
//                        "contact": "8606725216",
//                        "email": "a@b.com"
//                    ],
//                    "theme": [
//                        "color": "#336699"
//                    ]
//                ]
//        razorPay?.open(options)
//    }
//    
//    
//}
//
//extension RazorPayViewController : RazorpayPaymentCompletionProtocol {
//
//    func onPaymentError(_ code: Int32, description str: String) {
//        print("error: ", code, str)
//        self.presentAlert(withTitle: "Alert", message: str)
//    }
//
//    func onPaymentSuccess(_ payment_id: String) {
//        print("success: ", payment_id)
//        self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
//    }
//    
//    func presentAlert(withTitle title: String?, message: String?){
//        DispatchQueue.main.async {
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let OkAction = UIAlertAction(title: "Okay", style: .default)
//            alertController.addAction(OkAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//}
//
//struct MerchantDetails {
//    let name : String
//    let logo : String
//    let color : UIColor
//}
//
//extension MerchantDetails {
//    static func getDefaultData() -> MerchantDetails {
//        let details = MerchantDetails(name: "iOSPaymentGateway", logo: "https://img.freepik.com/free-vector/bird-colorful-gradient-design-vector_343694-2506.jpg?t=st=1721283674~exp=1721287274~hmac=6dac28cd7217e18721d9b3ca4038ad446101a3f5402786881b65779df1a79417&w=740", color: .red)
//        return details
//    }
//}
