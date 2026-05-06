
import UIKit
import ProgressHUD

final class SingleImageViewController: UIViewController {
    /*var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            
            imageView?.image = image
            /*imageView.frame.size = image.size*/
            rescaleAndCenterImageInScrollView(image: image)
        }
    }*/
    
    var photo: Photo?
    
    @IBOutlet private var imageView: UIImageView?

    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView?.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    private func loadImage() {
        print("1️⃣ imageView = \(imageView)")
        guard let photo = photo,
              let imageURL = URL(string: photo.largeImageURL) else {
            showError()
            return
        }
        
        /*UIBlockingProgressHUD.show()*/
        
        imageView?.kf.indicatorType = .activity
        
       imageView?.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
           
           
            guard let self = self else { return }
            
            switch result {
            case .success(let imageResult):
                self.imageView?.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadImage()
        })
        present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        guard let imageView = imageView else { return }
        guard let scrollView = scrollView else { return }
        
        view.layoutIfNeeded()
        
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        
        let fillScale = max(widthScale, heightScale)
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.maximumZoomScale = fillScale*2
        view.layoutIfNeeded()
        
        let imageViewSize = imageView.frame.size
        
        let horizontalInset = max(0, (scrollViewSize.width) - imageViewSize.width) / 2;
        let verticalInset = max(0, (scrollViewSize.height) - imageViewSize.height) / 2;
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

