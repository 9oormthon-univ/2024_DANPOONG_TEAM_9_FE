//
//  Onboarding2ViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit

class Onboarding2ViewController: UIViewController {

    // progress view
    @IBOutlet weak var progress2: UIProgressView!
    
    // label
    @IBOutlet weak var flowLabel2: UILabel!
    @IBOutlet weak var likeRegionLabel: UILabel!
    @IBOutlet weak var maxRegionLabel: UILabel!
    
    // button
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var seoulBtn: UIButton!
    @IBOutlet weak var gyeonggiBtn: UIButton!
    @IBOutlet weak var incheonBtn: UIButton!
    @IBOutlet weak var gangwonBtn: UIButton!
    @IBOutlet weak var daejeonBtn: UIButton!
    @IBOutlet weak var chungcheongBtn: UIButton!
    @IBOutlet weak var jeollaBtn: UIButton!
    @IBOutlet weak var gwangjuBtn: UIButton!
    @IBOutlet weak var gyeongsangBtn: UIButton!
    @IBOutlet weak var daeguBtn: UIButton!
    @IBOutlet weak var busanBtn: UIButton!
    @IBOutlet weak var ulsanBtn: UIButton!
    @IBOutlet weak var jejuBtn: UIButton!
    @IBOutlet weak var nextButton2: UIButton!
    
    // variable
    var isSeoulSelected = false
    var isGyeonggiSelected = false
    var isIncheonSelected = false
    var isGangwonSelected = false
    var isDaejeonSelected = false
    var isChungcheongSelected = false
    var isJeollaSelected = false
    var isGwangjuSelected = false
    var isGyeongsangSelected = false
    var isDaeguSelected = false
    var isBusanSelected = false
    var isUlsanSelected = false
    var isJejuSelected = false
    var didTapCnt : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFont()
        setupUI()
    }

    private func updateNextBtn2() {
        if didTapCnt == 1 {
            nextButton2.backgroundColor = UIColor(named: "SelectedGreen")
        }
        else {
            nextButton2.backgroundColor = UIColor(named: "DefaultGreen")
        }
    }
    
    private func setupFont() {
        flowLabel2.font = UIFont(name: "Pretendard-SemiBold", size: 13)
        likeRegionLabel.font = UIFont(name: "Pretendard-Bold", size: 25)
        maxRegionLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        nextButton2.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 18)
    }

    private func setupUI() {
        progress2.progress = 1.0
        
        let flowText = "2/2"
        let attributedString = NSMutableAttributedString(string: flowText)

        // 특정 범위의 텍스트에 색상을 적용
        let range = (flowText as NSString).range(of: "/2")
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.0667, green: 0.0667, blue: 0.0667, alpha: 0.5), range: range)

        flowLabel2.attributedText = attributedString
        
        maxRegionLabel.textColor = UIColor(red: 0.0667, green: 0.0667, blue: 0.0667, alpha: 0.4)
        
        seoulBtn.layer.cornerRadius = 22.5
        seoulBtn.layer.borderWidth = 1
        seoulBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        gyeonggiBtn.layer.cornerRadius = 22.5
        gyeonggiBtn.layer.borderWidth = 1
        gyeonggiBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        incheonBtn.layer.cornerRadius = 22.5
        incheonBtn.layer.borderWidth = 1
        incheonBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        gangwonBtn.layer.cornerRadius = 22.5
        gangwonBtn.layer.borderWidth = 1
        gangwonBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        daejeonBtn.layer.cornerRadius = 22.5
        daejeonBtn.layer.borderWidth = 1
        daejeonBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        chungcheongBtn.layer.cornerRadius = 22.5
        chungcheongBtn.layer.borderWidth = 1
        chungcheongBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        jeollaBtn.layer.cornerRadius = 22.5
        jeollaBtn.layer.borderWidth = 1
        jeollaBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        gwangjuBtn.layer.cornerRadius = 22.5
        gwangjuBtn.layer.borderWidth = 1
        gwangjuBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        gyeongsangBtn.layer.cornerRadius = 22.5
        gyeongsangBtn.layer.borderWidth = 1
        gyeongsangBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        daeguBtn.layer.cornerRadius = 22.5
        daeguBtn.layer.borderWidth = 1
        daeguBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        busanBtn.layer.cornerRadius = 22.5
        busanBtn.layer.borderWidth = 1
        busanBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        ulsanBtn.layer.cornerRadius = 22.5
        ulsanBtn.layer.borderWidth = 1
        ulsanBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        jejuBtn.layer.cornerRadius = 22.5
        jejuBtn.layer.borderWidth = 1
        jejuBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
        
        nextButton2.layer.cornerRadius = 27.5
    }
    
    // action
    @IBAction func didTapBackBtn(_ sender: Any) {
        guard let toOn1VC = self.storyboard?.instantiateViewController(withIdentifier: "Onboarding1ViewController") as? Onboarding1ViewController else { return }
            
        toOn1VC.modalPresentationStyle = .fullScreen
        
        // 전환 애니메이션 설정
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(toOn1VC, animated: false, completion: nil)
    }
    
    @IBAction func didTapSeoul(_ sender: Any) {
        if !isSeoulSelected && didTapCnt >= 1 {
            return
        }
        
        if isSeoulSelected {
            didTapCnt -= 1
            seoulBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            seoulBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            seoulBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            seoulBtn.layer.borderColor = UIColor.clear.cgColor
            seoulBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            seoulBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isSeoulSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapGyeonggi(_ sender: Any) {
        if !isGyeonggiSelected && didTapCnt >= 1 {
            return
        }
        
        if isGyeonggiSelected {
            didTapCnt -= 1
            gyeonggiBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            gyeonggiBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            gyeonggiBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            gyeonggiBtn.layer.borderColor = UIColor.clear.cgColor
            gyeonggiBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            gyeonggiBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isGyeonggiSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapIncheon(_ sender: Any) {
        if !isIncheonSelected && didTapCnt >= 1 {
            return
        }
        
        if isIncheonSelected {
            didTapCnt -= 1
            incheonBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            incheonBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            incheonBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            incheonBtn.layer.borderColor = UIColor.clear.cgColor
            incheonBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            incheonBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isIncheonSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapGangwon(_ sender: Any) {
        if !isGangwonSelected && didTapCnt >= 1 {
            return
        }
        
        if isGangwonSelected {
            didTapCnt -= 1
            gangwonBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            gangwonBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            gangwonBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            gangwonBtn.layer.borderColor = UIColor.clear.cgColor
            gangwonBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            gangwonBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isGangwonSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapDaejeon(_ sender: Any) {
        if !isDaejeonSelected && didTapCnt >= 1 {
            return
        }
        
        if isDaejeonSelected {
            didTapCnt -= 1
            daejeonBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            daejeonBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            daejeonBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            daejeonBtn.layer.borderColor = UIColor.clear.cgColor
            daejeonBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            daejeonBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isDaejeonSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapChungcheong(_ sender: Any) {
        if !isChungcheongSelected && didTapCnt >= 1 {
            return
        }
        
        if isChungcheongSelected {
            didTapCnt -= 1
            chungcheongBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            chungcheongBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            chungcheongBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            chungcheongBtn.layer.borderColor = UIColor.clear.cgColor
            chungcheongBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            chungcheongBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isChungcheongSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapJeolla(_ sender: Any) {
        if !isJeollaSelected && didTapCnt >= 1 {
            return
        }
        
        if isJeollaSelected {
            didTapCnt -= 1
            jeollaBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            jeollaBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            jeollaBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            jeollaBtn.layer.borderColor = UIColor.clear.cgColor
            jeollaBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            jeollaBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isJeollaSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapGwangju(_ sender: Any) {
        if !isGwangjuSelected && didTapCnt >= 1 {
            return
        }
        
        if isGwangjuSelected {
            didTapCnt -= 1
            gwangjuBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            gwangjuBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            gwangjuBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            gwangjuBtn.layer.borderColor = UIColor.clear.cgColor
            gwangjuBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            gwangjuBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isGwangjuSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapGyeongsang(_ sender: Any) {
        if !isGyeongsangSelected && didTapCnt >= 1 {
            return
        }
        
        if isGyeongsangSelected {
            didTapCnt -= 1
            gyeongsangBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            gyeongsangBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            gyeongsangBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            gyeongsangBtn.layer.borderColor = UIColor.clear.cgColor
            gyeongsangBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            gyeongsangBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isGyeongsangSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapDaegu(_ sender: Any) {
        if !isDaeguSelected && didTapCnt >= 1 {
            return
        }
        
        if isDaeguSelected {
            didTapCnt -= 1
            daeguBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            daeguBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            daeguBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            daeguBtn.layer.borderColor = UIColor.clear.cgColor
            daeguBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            daeguBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isDaeguSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapBusan(_ sender: Any) {
        if !isBusanSelected && didTapCnt >= 1 {
            return
        }
        
        if isBusanSelected {
            didTapCnt -= 1
            busanBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            busanBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            busanBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            busanBtn.layer.borderColor = UIColor.clear.cgColor
            busanBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            busanBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isBusanSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapUlsan(_ sender: Any) {
        if !isUlsanSelected && didTapCnt >= 1 {
            return
        }
        
        if isUlsanSelected {
            didTapCnt -= 1
            ulsanBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            ulsanBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            ulsanBtn.backgroundColor = UIColor(named: "ButtonBackground")
        } else {
            didTapCnt += 1
            ulsanBtn.layer.borderColor = UIColor.clear.cgColor
            ulsanBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            ulsanBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isUlsanSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapJeju(_ sender: Any) {
        if !isJejuSelected && didTapCnt >= 1 {
            return
        }
        
        if isJejuSelected {
            didTapCnt -= 1
            jejuBtn.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            jejuBtn.setTitleColor(UIColor(named: "DefaultGreen"), for: .normal)
            jejuBtn.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            jejuBtn.layer.borderColor = UIColor.clear.cgColor
            jejuBtn.setTitleColor(UIColor(named: "ButtonBackground"), for: .normal)
            jejuBtn.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isJejuSelected.toggle()
        updateNextBtn2()
    }
    
    @IBAction func didTapNextBtn2(_ sender: Any) {
        if didTapCnt != 1 {
            return
        }
        
        guard let toHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as? CustomTabBarViewController else { return }
        
        toHomeVC.modalPresentationStyle = .fullScreen
        toHomeVC.transitioningDelegate = self

        self.present(toHomeVC, animated: true, completion: nil)
    }
}

// extension
extension Onboarding2ViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition()
    }
}
