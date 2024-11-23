//
//  WriteReviewViewController.swift
//  LOCC_FE
//
//  Created by 성호은 on 11/23/24.
//

import UIKit
import Cosmos
import BSImagePicker
import Photos

class WriteReviewViewController: UIViewController {
    
    
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var photoView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var reviewText: UITextView!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var reviewBtn: UIButton!
    
    @IBOutlet weak var writeReviewLabel: UILabel!
    @IBOutlet weak var satisfyLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var detailReviewLabel: UILabel!
    @IBOutlet weak var exposeLabel: UILabel!
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var adDetailLabel: UILabel!
    
    
    
    private var userSelectedImages: [UIImage] = [] // 선택된 이미지를 저장하는 배열
    let photoLayout = UICollectionViewFlowLayout()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupDatePicker() // 날짜 선택기 설정
        reviewText.delegate = self
    }
    
    private func setupLabelUI() {
        writeReviewLabel.font = UIFont(name: "Pretendard-Bold", size: 18)
        satisfyLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        storeNameLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        detailReviewLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        exposeLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        adLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        adDetailLabel.font = UIFont(name: "Pretendard-Medium", size: 11)
    }
    
    private func setupUI() {
        // 별점 설정
        starRatingView.rating = 5
        starRatingView.settings.starMargin = 14
        starRatingView.settings.fillMode = .half
        starRatingView.settings.filledImage = UIImage(named: "icon_star_full") // 채워진 별
        starRatingView.settings.emptyImage = UIImage(named: "icon_star_unfull") // 빈 별
        
        // SearchBar 스타일
        if let backgroundImage = UIImage(color: UIColor.searchBar) {
            searchBar.setBackgroundImage(backgroundImage, for: .any, barMetrics: .default)
        }
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.borderStyle = .none
        searchBar.layer.cornerRadius = 10
        searchBar.clipsToBounds = true
        
        // Placeholder 텍스트 폰트 설정
        if let textField = searchBar.searchTextField as? UITextField {
            let placeholderText = "가게 검색하기"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Pretendard-Medium", size: 14)!,
                .foregroundColor: UIColor.reviewText
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
        
        // DateTextField 스타일
        dateTextField.layer.cornerRadius = 10
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.borderColor = UIColor.camera2.cgColor
        dateTextField.clipsToBounds = true
        
        // DateTextField Placeholder 설정
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Medium", size: 14)!,
            .foregroundColor: UIColor.camera // Placeholder 색상 설정
        ]
        dateTextField.attributedPlaceholder = NSAttributedString(
            string: "방문한 날짜", // Placeholder 텍스트
            attributes: placeholderAttributes
        )
        
        // DateTextField Padding 설정
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: dateTextField.frame.height))
        dateTextField.leftView = paddingView
        dateTextField.leftViewMode = .always
        
        // TextView 스타일
        reviewText.layer.cornerRadius = 10
        reviewText.text = "공간과 상품에 대한 솔직한 리뷰를 남겨주세요."
        reviewText.textColor = UIColor.reviewText
        
        // TextView Padding 설정
        reviewText.textContainerInset = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 16)
        reviewText.textContainer.lineFragmentPadding = 0
        
        reviewBtn.layer.cornerRadius = 10
    }
    
    private func setupCollectionView() {
        photoView.dataSource = self
        photoView.delegate = self
        
        let addPhotoNib = UINib(nibName: "AddPhotoCollectionViewCell", bundle: nil)
        let photoNib = UINib(nibName: "PhotoCollectionViewCell", bundle: nil)
        photoView.register(addPhotoNib, forCellWithReuseIdentifier: "addphotoCell")
        photoView.register(photoNib, forCellWithReuseIdentifier: "photoCell")
        
        photoLayout.scrollDirection = .horizontal
        photoView.collectionViewLayout = photoLayout
    }
    
    private func setupDatePicker() {
        // DatePicker 생성 및 설정
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels // 스타일 설정
        datePicker.locale = Locale(identifier: "ko_KR") // 한국어 로케일
        
        // Toolbar 생성
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        ], animated: true)
        
        // dateTextField에 DatePicker 연결
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        // 날짜 포맷 설정
        if let datePicker = dateTextField.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd" // 원하는 날짜 형식
            dateTextField.text = formatter.string(from: datePicker.date)
        }
        dateTextField.resignFirstResponder() // 키보드 닫기
    }
    
    // 이미지를 선택하고 추가하는 메서드
    private func presentImagePicker() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        presentImagePicker(imagePicker, select: { _ in
        }, deselect: { _ in
        }, cancel: { _ in
        }, finish: { assets in
            self.convertAssetToImages(assets: assets)
        })
    }
    
    private func convertAssetToImages(assets: [PHAsset]) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        assets.forEach { asset in
            imageManager.requestImage(for: asset,
                                      targetSize: CGSize(width: 200, height: 200),
                                      contentMode: .aspectFit,
                                      options: options) { result, _ in
                if let image = result {
                    self.userSelectedImages.append(image)
                }
            }
        }
        photoView.reloadData()
        
        updateReviewButtonState()
    }
    
    private func updateReviewButtonState() {
        if !userSelectedImages.isEmpty {
            reviewBtn.backgroundColor = UIColor.selectedGreen
        } else {
            reviewBtn.backgroundColor = UIColor.defaultGreen // 초기 상태
        }
    }
    
    // action
    @IBAction func uploadBtn(_ sender: Any) {
        guard let toHomeVC = storyboard?.instantiateViewController(withIdentifier: "CustomTabBarViewController") as? CustomTabBarViewController else { return }
        toHomeVC.modalPresentationStyle = .fullScreen
        present(toHomeVC, animated: true, completion: nil)
    }
    
}

extension WriteReviewViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userSelectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addphotoCell", for: indexPath) as? AddPhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.cameraBtn.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            let image = userSelectedImages[indexPath.item - 1]
            cell.photoImg.image = image
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    @objc private func didTapCameraButton() {
        presentImagePicker()
    }
}

extension WriteReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.reviewText && textView.text == "공간과 상품에 대한 솔직한 리뷰를 남겨주세요." {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "공간과 상품에 대한 솔직한 리뷰를 남겨주세요."
            textView.textColor = UIColor.reviewText
        }
    }
}
