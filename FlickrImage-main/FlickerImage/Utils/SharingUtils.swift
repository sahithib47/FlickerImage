import UIKit

class SharingUtils {
    static func shareImageAndMetadata(image: UIImage?, title: String, description: String) {
        guard let image = image else { return }

        let activityItems: [Any] = [image, "Title: \(title)", "Description: \(TextUtils.stripHTMLTags(description))"]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
