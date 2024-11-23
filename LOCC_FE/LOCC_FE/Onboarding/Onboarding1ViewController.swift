//
//  Onboarding1ViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/18/24.
//

import UIKit
import Alamofire

class Onboarding1ViewController: UIViewController {
    
    // progress view
    @IBOutlet weak var progress1: UIProgressView!
    
    // label
    @IBOutlet weak var flowLabel1: UILabel!
    @IBOutlet weak var likeCategoryLabel: UILabel!
    @IBOutlet weak var maxCategoryLabel: UILabel!
    
    // button
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var craftButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var townstoreButton: UIButton!
    @IBOutlet weak var bookstoreButton: UIButton!
    @IBOutlet weak var spaceButton: UIButton!
    @IBOutlet weak var accomodationButton: UIButton!
    @IBOutlet weak var nextButton1: UIButton!
    
    // view
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var cafeView: UIView!
    @IBOutlet weak var craftView: UIView!
    @IBOutlet weak var shoppingView: UIView!
    @IBOutlet weak var townstoreView: UIView!
    @IBOutlet weak var bookstoreView: UIView!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var accomodationView: UIView!
    
    // variable
    var isFoodSelected = false
    var isRestaurantSelected = false
    var isCafeSelected = false
    var isCraftSelected = false
    var isShoppingSelected = false
    var isTownStoreSelected = false
    var isBookstoreSelected = false
    var isSpaceSelected = false
    var isAccomodationSelected = false
    var didTapCnt : Int = 0
    
    // instance
    var onboardingData = OnboardingData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFont()
        setupUI()
        updateNextBtn1()
    }
    
    private func updateNextBtn1() {
        if didTapCnt == 2 {
            nextButton1.backgroundColor = UIColor.selectedGreen
        }
        else {
            nextButton1.backgroundColor = UIColor.defaultGreen
        }
    }
    
    private func setupFont() {
        flowLabel1.font = UIFont(name: "Pretendard-Semibold", size: 13)
        likeCategoryLabel.font = UIFont(name: "Pretendard-Bold", size: 30)
        maxCategoryLabel.font = UIFont(name: "Pretendard-Medium", size: 15)
        nextButton1.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 18)
    }
    
    private func setupUI() {
        let flowText = "1/2"
        let attributedString = NSMutableAttributedString(string: flowText)

        // 특정 범위의 텍스트에 색상을 적용
        let range = (flowText as NSString).range(of: "/2")
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.0667, green: 0.0667, blue: 0.0667, alpha: 0.5), range: range)

        flowLabel1.attributedText = attributedString
        
        maxCategoryLabel.textColor = UIColor(red: 0.0667, green: 0.0667, blue: 0.0667, alpha: 0.4)
        
        
        // 온보딩 카페고리 버튼 ui
        foodView.layer.cornerRadius = 15.62
        foodView.layer.borderWidth = 0.87
        foodView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        restaurantView.layer.cornerRadius = 15.62
        restaurantView.layer.borderWidth = 0.87
        restaurantView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        cafeView.layer.cornerRadius = 15.62
        cafeView.layer.borderWidth = 0.87
        cafeView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        craftView.layer.cornerRadius = 15.62
        craftView.layer.borderWidth = 0.87
        craftView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        shoppingView.layer.cornerRadius = 15.62
        shoppingView.layer.borderWidth = 0.87
        shoppingView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        townstoreView.layer.cornerRadius = 15.62
        townstoreView.layer.borderWidth = 0.87
        townstoreView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        bookstoreView.layer.cornerRadius = 15.62
        bookstoreView.layer.borderWidth = 0.87
        bookstoreView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        spaceView.layer.cornerRadius = 15.62
        spaceView.layer.borderWidth = 0.87
        spaceView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        accomodationView.layer.cornerRadius = 15.62
        accomodationView.layer.borderWidth = 0.87
        accomodationView.layer.borderColor = UIColor.defaultGreen.cgColor
        
        // 온보딩 다음 버튼 ui
        nextButton1.layer.cornerRadius = 27.5
    }
    
    // action
    @IBAction func didTapFood(_ sender: Any) {
        if !isFoodSelected && didTapCnt >= 2 {
            return
        }
        
        if isFoodSelected {
            didTapCnt -= 1
            foodButton.setImage(UIImage(named: "on_food")?.withRenderingMode(.alwaysTemplate), for: .normal)
            foodButton.tintColor = UIColor(named: "DefaultGreen")
            foodView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            foodView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            foodButton.setImage(UIImage(named: "on_food")?.withRenderingMode(.alwaysTemplate), for: .normal)
            foodButton.tintColor = .white
            foodView.layer.borderColor = UIColor.clear.cgColor
            foodView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isFoodSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapRestaurant(_ sender: Any) {
        if !isRestaurantSelected && didTapCnt >= 2 {
            return
        }
        
        if isRestaurantSelected {
            didTapCnt -= 1
            restaurantButton.setImage(UIImage(named: "on_restaurant")?.withRenderingMode(.alwaysTemplate), for: .normal)
            restaurantButton.tintColor = UIColor(named: "DefaultGreen")
            restaurantView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            restaurantView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            restaurantButton.setImage(UIImage(named: "on_restaurant")?.withRenderingMode(.alwaysTemplate), for: .normal)
            restaurantButton.tintColor = .white
            restaurantView.layer.borderColor = UIColor.clear.cgColor
            restaurantView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isRestaurantSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapCafe(_ sender: Any) {
        if !isCafeSelected && didTapCnt >= 2 {
            return
        }
        
        if isCafeSelected {
            didTapCnt -= 1
            cafeButton.setImage(UIImage(named: "on_cafe")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cafeButton.tintColor = UIColor(named: "DefaultGreen")
            cafeView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            cafeView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            cafeButton.setImage(UIImage(named: "on_cafe")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cafeButton.tintColor = .white
            cafeView.layer.borderColor = UIColor.clear.cgColor
            cafeView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isCafeSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapCraft(_ sender: Any) {
        if !isCraftSelected && didTapCnt >= 2 {
            return
        }
        
        if isCraftSelected {
            didTapCnt -= 1
            craftButton.setImage(UIImage(named: "on_craft2")?.withRenderingMode(.alwaysTemplate), for: .normal)
            craftButton.tintColor = UIColor(named: "DefaultGreen")
            craftView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            craftView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            craftButton.setImage(UIImage(named: "on_craft2")?.withRenderingMode(.alwaysTemplate), for: .normal)
            craftButton.tintColor = .white
            craftView.layer.borderColor = UIColor.clear.cgColor
            craftView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isCraftSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapShopping(_ sender: Any) {
        if !isShoppingSelected && didTapCnt >= 2 {
            return
        }
        
        if isShoppingSelected {
            didTapCnt -= 1
            shoppingButton.setImage(UIImage(named: "on_shopping")?.withRenderingMode(.alwaysTemplate), for: .normal)
            shoppingButton.tintColor = UIColor(named: "DefaultGreen")
            shoppingView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            shoppingView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            shoppingButton.setImage(UIImage(named: "on_shopping")?.withRenderingMode(.alwaysTemplate), for: .normal)
            shoppingButton.tintColor = .white
            shoppingView.layer.borderColor = UIColor.clear.cgColor
            shoppingView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isShoppingSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapTownStore(_ sender: Any) {
        if !isTownStoreSelected && didTapCnt >= 2 {
            return
        }
        
        if isTownStoreSelected {
            didTapCnt -= 1
            townstoreButton.setImage(UIImage(named: "on_online")?.withRenderingMode(.alwaysTemplate), for: .normal)
            townstoreButton.tintColor = UIColor(named: "DefaultGreen")
            townstoreView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            townstoreView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            townstoreButton.setImage(UIImage(named: "on_online")?.withRenderingMode(.alwaysTemplate), for: .normal)
            townstoreButton.tintColor = .white
            townstoreView.layer.borderColor = UIColor.clear.cgColor
            townstoreView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isTownStoreSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapBookstore(_ sender: Any) {
        if !isBookstoreSelected && didTapCnt >= 2 {
            return
        }
        
        if isBookstoreSelected {
            didTapCnt -= 1
            bookstoreButton.setImage(UIImage(named: "on_culture")?.withRenderingMode(.alwaysTemplate), for: .normal)
            bookstoreButton.tintColor = UIColor(named: "DefaultGreen")
            bookstoreView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            bookstoreView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            bookstoreButton.setImage(UIImage(named: "on_culture")?.withRenderingMode(.alwaysTemplate), for: .normal)
            bookstoreButton.tintColor = .white
            bookstoreView.layer.borderColor = UIColor.clear.cgColor
            bookstoreView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isBookstoreSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapSpace(_ sender: Any) {
        if !isSpaceSelected && didTapCnt >= 2 {
            return
        }
        
        if isSpaceSelected {
            didTapCnt -= 1
            spaceButton.setImage(UIImage(named: "on_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
            spaceButton.tintColor = UIColor(named: "DefaultGreen")
            spaceView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            spaceView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            spaceButton.setImage(UIImage(named: "on_bar")?.withRenderingMode(.alwaysTemplate), for: .normal)
            spaceButton.tintColor = .white
            spaceView.layer.borderColor = UIColor.clear.cgColor
            spaceView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isSpaceSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapAccomodation(_ sender: Any) {
        if !isAccomodationSelected && didTapCnt >= 2 {
            return
        }
        
        if isAccomodationSelected {
            didTapCnt -= 1
            accomodationButton.setImage(UIImage(named: "on_accomodation")?.withRenderingMode(.alwaysTemplate), for: .normal)
            accomodationButton.tintColor = UIColor(named: "DefaultGreen")
            accomodationView.layer.borderColor = UIColor(named: "DefaultGreen")?.cgColor
            accomodationView.backgroundColor = UIColor(named: "ButtonBackground")
        }
        else {
            didTapCnt += 1
            accomodationButton.setImage(UIImage(named: "on_accomodation")?.withRenderingMode(.alwaysTemplate), for: .normal)
            accomodationButton.tintColor = .white
            accomodationView.layer.borderColor = UIColor.clear.cgColor
            accomodationView.backgroundColor = UIColor(named: "SelectedGreen")
        }
        
        isAccomodationSelected.toggle()
        updateNextBtn1()
    }
    
    @IBAction func didTapNextBtn1(_ sender: Any) {
        if didTapCnt != 2 {
            return
        }
        
        // 선택된 카테고리를 저장
        var selectedCategories = [String]()
        if isFoodSelected { selectedCategories.append("식품") }
        if isRestaurantSelected { selectedCategories.append("맛집") }
        if isCafeSelected { selectedCategories.append("카페") }
        if isCraftSelected { selectedCategories.append("체험/공방") }
        if isShoppingSelected { selectedCategories.append("쇼핑") }
        if isTownStoreSelected { selectedCategories.append("온라인") }
        if isBookstoreSelected { selectedCategories.append("문화") }
        if isSpaceSelected { selectedCategories.append("술집") }
        if isAccomodationSelected { selectedCategories.append("숙소") }
        
        onboardingData.selectedCategories = selectedCategories
        
        // 다음 화면으로 데이터 전달
        guard let toOn2VC = storyboard?.instantiateViewController(withIdentifier: "Onboarding2ViewController") as? Onboarding2ViewController else { return }
        toOn2VC.onboardingData = onboardingData
        toOn2VC.modalPresentationStyle = .fullScreen
        toOn2VC.transitioningDelegate = self
        present(toOn2VC, animated: true, completion: nil)
    }
}

// extension
extension Onboarding1ViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransition()
    }
}
