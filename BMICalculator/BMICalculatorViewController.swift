//
//  BMICalculatorViewController.swift
//  BMICalculator
//
//  Created by SUCHAN CHANG on 1/3/24.
//

import UIKit

class BMICalculatorViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var heightInquiryLabel: UILabel!
    @IBOutlet weak var heightInputStackView: UIStackView!
    @IBOutlet weak var heightInputTextField: UITextField!
    
    @IBOutlet weak var weightInquiryLabel: UILabel!
    @IBOutlet weak var weightInputStackView: UIStackView!
    @IBOutlet weak var weightInputTextField: UITextField!
    @IBOutlet weak var showAndHideButton: UIButton!

    @IBOutlet weak var randomBMICalculationButton: UIButton!
    
    @IBOutlet weak var showResultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - UI 디자인 관련 메소드
    private func configureUI() {
        designLabel(
            titleLabel,
            text: "BMI Calculator",
            font: .systemFont(ofSize: 25.0, weight: .bold)
        )
        
        designLabel(
            subtitleLabel,
            text: "당신의 BMI 지수를\n알려드릴게요.",
            font: .systemFont(ofSize: 15.0)
        )
        
        designCharacterImageView()
        
        designLabel(
            heightInquiryLabel,
            text: "키가 어떻게 되시나요?",
            font: .systemFont(ofSize: 15.0)
        )
        
        designStackView(heightInputStackView)

        designTextField(heightInputTextField)
        
        designLabel(
            weightInquiryLabel,
            text: "몸무게는 어떻게 되시나요?",
            font: .systemFont(ofSize: 15.0)
        )
        
        designStackView(weightInputStackView)
        
        designTextField(weightInputTextField)
        
        designShowAndHideButton()
        
        designButton(randomBMICalculationButton, title: "랜덤으로 BMI 계산하기", titleColor: .red, font: .systemFont(ofSize: 15.0))
        
        designButton(showResultButton, title: "결과 확인", titleColor: .white, font: .systemFont(ofSize: 22.0), cornerRadius: 10, backgroundColor: .purple)
    }
    
    private func designLabel(_ label: UILabel, text: String, font: UIFont, textAlignment: NSTextAlignment = .left) {
        label.text = text
        label.font = font
        label.textAlignment = textAlignment
    }
    
    private func designStackView(_ stackView: UIStackView) {
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 16
    }
    
    private func designTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
    }
    
    private func designButton(
        _ button: UIButton,
        title: String,
        titleColor: UIColor,
        font: UIFont? = nil,
        cornerRadius: CGFloat? = nil,
        backgroundColor: UIColor = .clear
    ) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor

        if let font = font {
            button.titleLabel?.font = font
        }
        
        if let cornerRadius = cornerRadius {
            button.layer.cornerRadius = cornerRadius
        }
    }
    
    private func designShowAndHideButton() {
        let showAndHideButtonImage = UIImage(systemName: "eye.slash")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        showAndHideButton.setImage(showAndHideButtonImage, for: .normal)
        showAndHideButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
    }
    
    private func designCharacterImageView() {
        characterImageView.image = UIImage(named: "image")
        characterImageView.contentMode = .scaleAspectFit
    }
    
    private func showAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "확인", style: .default)
     
        alert.addAction(confirmButton)
        
        present(alert, animated: true)
    }
    
    // MARK: - 유저 이벤트 관련 메소드
    @IBAction func inputTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            showAlertController(
                title: "입력 오류",
                message: "숫자가 제대로 입력되지 않았습니다."
            )
            return
        }
        
        // 글자수 3자리로 제한 및 숫자만 입력되는지 판별
        if text.count > 3 || !containsOnlyDigits(text) {
            sender.deleteBackward()
        }
    }
    
    @IBAction func randomCalculationButtonTapped(_ sender: UIButton) {
        let randomHeight = Int.random(in: 150...200)
        let randomWeight = Int.random(in: 40...100)
        
        heightInputTextField.text = randomHeight.description
        weightInputTextField.text = randomWeight.description
        
        let bmiResult = calculateBMI(height: Float(randomHeight), weight: Float(randomWeight))
        showAlertController(
            title: "BMI 지수 계산 결과",
            message: "\(evaluateBMIStage(bmiFigure: bmiResult))\n\(bmiResult)"
        )
    }
    
    @IBAction func showResultButtonTapped(_ sender: UIButton) {
        guard
            let height = Float(heightInputTextField.text!),
            let weight = Float(weightInputTextField.text!)
        else {
            showAlertController(
                title: "입력 오류",
                message: "키와 몸무게 제대로 입력되지 않았습니다."
            )
            return
        }
        
        catchErrors(height: height, weight: weight)
        
        let bmiResult = calculateBMI(height: height, weight: weight)
        showAlertController(
            title: "BMI 지수 계산 결과",
            message: "\(evaluateBMIStage(bmiFigure: bmiResult))\n\(bmiResult)"
        )
    }
    
    @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func calculateBMI(height: Float, weight: Float) -> Float {
        let calculatedBmi = weight / pow(height * 0.01, 2)
        let digit: Float = pow(10, 2)
        return round(calculatedBmi * digit) / digit // 소수 세번째 자리에서 반올림
    }
    
    private func evaluateBMIStage(bmiFigure: Float) -> String {
        switch bmiFigure {
        case 0..<18.5:
            return "저체중"
        case 18.5..<25:
            return "정상"
        case 25..<30:
            return "과체중"
        case 30..<35:
            return "1단계 비만"
        case 35..<40:
            return "2단계 비만"
        default:
            return "3단계 비만"
        }
    }
    
    private func catchErrors(height: Float, weight: Float) {
        if 0..<150 ~= height && 0..<40 ~= weight {
            showAlertController(
                title: "범위 오류",
                message: "키와 몸무게가 너무 낮게 입력되었습니다."
            )
        } else if 0..<150 ~= height && weight > 100 {
            showAlertController(
                title: "범위 오류",
                message: "키는 너무 낮게 입력되었고, 몸무게는 너무 높게 입력되었습니다."
            )
        } else if height > 200 && 0..<40 ~= weight {
            showAlertController(
                title: "범위 오류",
                message: "키는 너무 높게 입력되었고, 몸무게는 너무 낮게 입력되었습니다."
            )
        } else if height > 200 && weight > 100 {
            showAlertController(
                title: "범위 오류",
                message: "키와 몸무게 모두 너무 높게 입력되었습니다."
            )
        } else if 0..<150 ~= height {
            showAlertController(
                title: "범위 오류",
                message: "키가 너무 낮게 입력되었습니다."
            )
        } else if height > 200 {
            showAlertController(
                title: "범위 오류",
                message: "키가 너무 높게 입력되었습니다."
            )
        } else if 0..<40 ~= weight {
            showAlertController(
                title: "범위 오류",
                message: "몸무게가 너무 낮게 입력되었습니다."
            )
        } else if weight > 100 {
            showAlertController(
                title: "범위 오류",
                message: "몸무게가 너무 높게 입력되었습니다."
            )
        }
    }
    
    private func containsOnlyDigits(_ input: String) -> Bool {
        let pattern = "^[0-9]+$"
        guard let _ = input.range(of: pattern, options: .regularExpression) else { return false }
        return true
    }
}
