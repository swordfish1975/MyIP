//
//  ViewController.swift
//  MyIP
//
//  Created by konstantin on 26/08/2018.
//  Copyright © 2018 konstantin. All rights reserved.
//

import UIKit
// получение ip-adress с интерфейса en0 (Wi-Fi) тип данных String, или `nil`
func getWiFiAddress() -> String? {
    var address : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        
        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
            
            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if  name == "en0" {
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)
    
    return address
}
class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.isHidden = true
        label.font = label.font.withSize(20)
        label.textColor = .red
        button.setTitle("РЕЗУЛЬТАТ", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .green
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func pressedButton(_ sender: UIButton) {
        if label.isHidden {
            label.isHidden = false
            label.text  = "My IP-address: \(String(describing: getWiFiAddress()! ))"
            
            button.setTitle("ОЧИСТИТЬ", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .red
        } else {
            label.isHidden = true
            button.setTitle("РЕЗУЛЬТАТ", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .green
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

