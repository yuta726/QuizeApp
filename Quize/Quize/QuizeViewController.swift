//
//  QuizeViewController.swift
//  Quize
//
//  Created by 中村優太 on 2023/06/24.
//

import UIKit

class QuizeViewController: UIViewController {
    @IBOutlet weak var quizeNumberLabel: UILabel!
    @IBOutlet weak var quizeTeztView: UITextView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var judgeImageView: UIImageView!
    
    var csvArray: [String] = []
    var quizeArray: [String] = []
    var quizeCount = 0
    var correctCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csvArray = loadCSV(fileName: "quiz")
        
        quizeArray = csvArray[quizeCount].components(separatedBy: ",")
        print(quizeArray)
        quizeNumberLabel.text = "第\(quizeCount+1)問"
        quizeTeztView.text = quizeArray[0]
        answerButton1.setTitle(quizeArray[2], for: .normal)
        answerButton2.setTitle(quizeArray[3], for: .normal)
        answerButton3.setTitle(quizeArray[4], for: .normal)
        answerButton4.setTitle(quizeArray[5], for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
    }
    
    @IBAction func btnAction(sender: UIButton){
        if sender.tag == Int(quizeArray[1]){
            print("正解")
            correctCount += 1
            judgeImageView.image = UIImage(named: "correct")
        }else{
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
        }
        judgeImageView.isHidden = false
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
        answerButton4.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.judgeImageView.isHidden = true
            self.answerButton1.isEnabled = true
            self.answerButton2.isEnabled = true
            self.answerButton3.isEnabled = true
            self.answerButton4.isEnabled = true
            self.nextQuize()
        }
    }
    
    func nextQuize(){
        quizeCount += 1
        if quizeCount < csvArray.count{
            quizeArray = csvArray[quizeCount].components(separatedBy: ",")
            quizeNumberLabel.text = "第\(quizeCount+1)問"
            quizeTeztView.text = quizeArray[0]
            answerButton1.setTitle(quizeArray[2], for: .normal)
            answerButton2.setTitle(quizeArray[3], for: .normal)
            answerButton3.setTitle(quizeArray[4], for: .normal)
            answerButton4.setTitle(quizeArray[5], for: .normal)
        }else{
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }
    
    func loadCSV(fileName: String) -> [String]{
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do{
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        }catch{
            print("エラー")
        }
        return csvArray
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
