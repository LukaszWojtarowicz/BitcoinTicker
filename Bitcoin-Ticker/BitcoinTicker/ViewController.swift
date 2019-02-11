//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//  Modifyed by lukasz on 11/02/2019

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    //UIPickerView delegate methods here
    //first three methods configures component
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return currencyArray[row]
    }

    // this method describes behavior after clicking on name
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // print(currencyArray[row])
        finalURL = baseURL + currencyArray[row]
       // print(finalURL)
        getBitcoinData(url: finalURL)
    }

    //MARK: - Networking
    /***************************************************************/

    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON: JSON = JSON(response.result.value!)
                   // print(bitcoinJSON)
                    self.updateBitcoinData(json: bitcoinJSON)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }

    //MARK: - JSON Parsing
    /***************************************************************/

    func updateBitcoinData(json: JSON) {

        if let bitcoinResult = json["averages"]["day"].double {
            //print("Price:" + String(bitcoinResult))
            bitcoinPriceLabel.text = String(bitcoinResult)
        }
        else {
            bitcoinPriceLabel.text = "Data unavailable"
        }
    }
}
