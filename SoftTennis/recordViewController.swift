//
//  recordViewController.swift
//  SoftTennis
//
//  Created by 山下優斗 on 2022/11/22.
//

import UIKit
protocol RecordTableViewCellDelegate: AnyObject {
    func didChangeLeftCount()
    func didChangeRightCount()
}
class recordViewController: UIViewController {
    
    // UndoManagerのインスタンス作成
    var customUndoManager = UndoManager()
    
    private var time: Double = 0.0
    private var timer: Timer?
    private var isTimerRunning: Bool = false
    @IBOutlet weak var LeftTeam: UILabel!
    @IBOutlet weak var RightTeam: UILabel!
    
    @IBOutlet weak var LeftPlayer1: UILabel!
    @IBOutlet weak var RightPlayer1: UILabel!
    
    @IBOutlet weak var LeftPlayer2: UILabel!
    @IBOutlet weak var RightPlayer2: UILabel!
    @IBOutlet weak var LeftGamePoint: UILabel!
    @IBOutlet weak var RightGamePoint: UILabel!
    @IBOutlet weak var RecordTableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var LeftTeamText: String?
    var RightTeamText: String?
    var LeftPlayer1Text: String?
    var LeftPlayer2Text: String?
    var RightPlayer1Text: String?
    var RightPlayer2Text: String?
    
    func updateLeftGamePointCount() {
            var count = 0
            for row in 0..<RecordTableView.numberOfRows(inSection: 0) {
                if let cell = RecordTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? RecordTableViewCell, cell.leftresult == true{
                    count += 1
                }
            }
            LeftGamePoint.text = "\(count)"
        }
    func updateRightGamePointCount() {
            var count = 0
            for row in 0..<RecordTableView.numberOfRows(inSection: 0) {
                if let cell = RecordTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? RecordTableViewCell, cell.rightresult == true {
                    count += 1
                }
            }
            RightGamePoint.text = "\(count)"
        }
    @IBAction func undoButtonTapped(_ sender: UIButton) {
        if customUndoManager.canUndo {
            customUndoManager.undo()
            updateLeftGamePointCount()
            updateRightGamePointCount()
        }
    }
    
    
    @IBAction func tappedStart(_ sender: UIButton) {
        if isTimerRunning {
                return // タイマーが実行中の場合は何もしない
            }
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.time += 0.01
            let minutes = Int(self.time / 60)
            let seconds = Int(self.time) % 60
            self.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
        
        isTimerRunning = true
        stopButton.setTitle("STOP", for: .normal)
    }

    @IBAction func tappedStop(_ sender: UIButton) {
        if isTimerRunning {
                timer?.invalidate()
                isTimerRunning = false
                stopButton.setTitle("RESET", for: .normal)
            
            } else {
                time = 0.0
                timerLabel.text = "00:00"
                stopButton.setTitle("STOP", for: .normal)
            }
    }

  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecordTableView.delegate = self
        RecordTableView.dataSource = self
        LeftTeam.text = LeftTeamText
        RightTeam.text = RightTeamText
        LeftPlayer1.text = LeftPlayer1Text
        LeftPlayer2.text = LeftPlayer2Text
        RightPlayer1.text = RightPlayer1Text
        RightPlayer2.text = RightPlayer2Text

        // Do any additional setup after loading the view.
    }
    

    

}

extension recordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let selectedNumber = UserDefaults.standard.integer(forKey: "SelectedNumber")
            return selectedNumber // 選択された数字がセルの数になります
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordTableViewCell
        cell.viewControllerUndoManager = customUndoManager
        cell.delegate = self
        cell.GameCountLabel.text = "-\(indexPath.row + 1)-"
        return cell
    }
    
}
extension recordViewController: RecordTableViewCellDelegate {
    func didChangeLeftCount() {
        updateLeftGamePointCount()
    }
    func didChangeRightCount() {
        updateRightGamePointCount()
    }
}

class RecordTableViewCell:UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource{
    weak var delegate: RecordTableViewCellDelegate?
    var viewControllerUndoManager: UndoManager?
    @IBOutlet weak var GameCountLabel: UILabel!
    @IBOutlet weak var LeftPickerView: UIPickerView!
    @IBOutlet weak var LeftPointButton: UIButton!
    @IBOutlet weak var LeftPointLabel: UILabel!
    @IBOutlet weak var RightPointLabel: UILabel!
    @IBOutlet weak var RightPointButton: UIButton!
    @IBOutlet weak var RightPickerView: UIPickerView!
    let dataList = ["S" , "R"]
    var leftresult: Bool = false
    var rightresult: Bool = false
    var leftcount: Int = 0 {
        didSet {
            LeftPointLabel.text = "\(leftcount)"
            // leftcountが4になった場合の処理
            if leftcount == 4 && rightcount <= 2  {
                            // LeftPointLabelを角丸の枠で囲む
                LeftPointLabel.layer.borderWidth = 2.0 // 枠の太さ
                LeftPointLabel.layer.borderColor = UIColor.black.cgColor // 枠の色
                LeftPointLabel.layer.cornerRadius = 5.0 // 角丸の半径
                LeftPointLabel.clipsToBounds = true // このプロパティをtrueに設定して、サブビューがビューの境界内に収まるようにする

                            // leftbuttonTappedを無効にする
                LeftPointButton.isEnabled = false
                RightPointButton.isEnabled = false
                leftresult = true
                }
            else if ( leftcount - rightcount == 2 ) && rightcount >= 3  {
                // LeftPointLabelを角丸の枠で囲む
                LeftPointLabel.layer.borderWidth = 2.0 // 枠の太さ
                LeftPointLabel.layer.borderColor = UIColor.black.cgColor // 枠の色
                LeftPointLabel.layer.cornerRadius = 5.0 // 角丸の半径
                LeftPointLabel.clipsToBounds = true // このプロパティをtrueに設定して、サブビューがビューの境界内に収まるようにする

                // leftbuttonTappedを無効にする
                LeftPointButton.isEnabled = false
                RightPointButton.isEnabled = false
                leftresult = true
            }
            else{
                LeftPointLabel.layer.borderWidth = 0
                LeftPointButton.isEnabled = true
                RightPointButton.isEnabled = true
                leftresult = false
            }
            delegate?.didChangeLeftCount()
            
        }
        
    }
    
    @IBAction func leftbuttonTapped(_ sender: UIButton) {
        // 現在のleftcountの値を保持し、incrementした後の動作をUndoManagerに登録
        self.viewControllerUndoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
            targetSelf.leftcount -= 1
        })
        leftcount += 1
        
        
    }
    
    var rightcount: Int = 0 {
        didSet {
            RightPointLabel.text = "\(rightcount)"
            
            if rightcount == 4  && leftcount <= 2{
                            
                RightPointLabel.layer.borderWidth = 2.0 // 枠の太さ
                RightPointLabel.layer.borderColor = UIColor.black.cgColor // 枠の色
                RightPointLabel.layer.cornerRadius = 5.0 // 角丸の半径
                RightPointLabel.clipsToBounds = true // このプロパティをtrueに設定して、サブビューがビューの境界内に収まるようにする

                            
                LeftPointButton.isEnabled = false
                RightPointButton.isEnabled = false
                rightresult = true
                }
            else if ( rightcount - leftcount == 2 ) && leftcount >= 3 {
                RightPointLabel.layer.borderWidth = 2.0 // 枠の太さ
                RightPointLabel.layer.borderColor = UIColor.black.cgColor // 枠の色
                RightPointLabel.layer.cornerRadius = 5.0 // 角丸の半径
                RightPointLabel.clipsToBounds = true // このプロパティをtrueに設定して、サブビューがビューの境界内に収まるようにする

                            
                LeftPointButton.isEnabled = false
                RightPointButton.isEnabled = false
                rightresult = true
            }
            else{
                RightPointLabel.layer.borderWidth = 0
                LeftPointButton.isEnabled = true
                RightPointButton.isEnabled = true
                rightresult = false
            }
            delegate?.didChangeRightCount()
        }
        
    }
    
    @IBAction func rightbuttonTapped(_ sender: UIButton) {
        // 現在のrightcountの値を保持し、incrementした後の動作をUndoManagerに登録
        self.viewControllerUndoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
            targetSelf.rightcount -= 1
        })
        rightcount += 1
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        LeftPickerView.delegate = self
        LeftPickerView.dataSource = self
        RightPickerView.delegate = self
        RightPickerView.dataSource = self
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // ここでPickerViewの列数を返します
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // ここで各列の行数を返します
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // ここで各行のタイトルを返します（オプショナル）
        return dataList[row]
    }
}
