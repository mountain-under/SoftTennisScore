//
//  gamecountViewController.swift
//  SoftTennis
//
//  Created by 山下優斗 on 2023/08/07.
//

import UIKit

class gamecountViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var LeftTeamTextField: UITextField!
    @IBOutlet weak var LeftTextField1: UITextField!
    
    @IBOutlet weak var LeftTextField2: UITextField!
    
    @IBOutlet weak var RightTeamTextField: UITextField!
    @IBOutlet weak var RightTextField1: UITextField!
    
    @IBOutlet weak var RightTextField2: UITextField!
    @IBOutlet weak var recordtransition: UIButton!
    @IBOutlet weak var gamecountpickerView: UIPickerView!
    
    let dataList = [
            "1","3","5","7","9"
        ]
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            LeftTeamTextField.placeholder = "チーム1"
            LeftTextField1.placeholder = "チーム1のプレイヤー1"
            LeftTextField2.placeholder = "チーム1のプレイヤー2"
            RightTeamTextField.placeholder = "チーム2"
            RightTextField1.placeholder = "チーム2のプレイヤー1"
            RightTextField2.placeholder = "チーム2のプレイヤー2"
            
            // Delegate設定
            gamecountpickerView.delegate = self
            gamecountpickerView.dataSource = self
            gamecountpickerView.selectRow(2, inComponent: 0, animated: true)
            let defaultNumber = dataList[2]
            UserDefaults.standard.set(defaultNumber, forKey: "SelectedNumber")
        }
        
        // UIPickerViewの列の数
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // UIPickerViewの行数、リストの数
        func pickerView(_ pickerView: UIPickerView,
                        numberOfRowsInComponent component: Int) -> Int {
            return dataList.count
        }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // ここで各行のタイトルを返します（オプショナル）
        return dataList[row] + "ゲーム"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber = dataList[row] // dataListはPickerViewに表示されるデータの配列
        UserDefaults.standard.set(selectedNumber, forKey: "SelectedNumber")
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "YourSegueIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YourSegueIdentifier" {
            let destinationVC = segue.destination as! recordViewController
            destinationVC.LeftTeamText = LeftTeamTextField.text
            destinationVC.RightTeamText = RightTeamTextField.text
            destinationVC.LeftPlayer1Text = LeftTextField1.text
            destinationVC.LeftPlayer2Text = LeftTextField2.text
            destinationVC.RightPlayer1Text = RightTextField1.text
            destinationVC.RightPlayer2Text = RightTextField2.text
        }
    }



}
