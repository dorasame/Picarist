import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: UIImage?
    @Binding var isCaptured: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: UIImage?
        @Binding var isCaptured: Bool

        init(presentationMode: Binding<PresentationMode>, image: Binding<UIImage?>, isCaptured: Binding<Bool>) {
            _presentationMode = presentationMode
            _image = image
            _isCaptured = isCaptured
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let uiImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            image = imageResize(uiImage: uiImage)
            isCaptured = true
            presentationMode.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
        func imageResize(uiImage: UIImage) -> UIImage {
            var newImage: UIImage?
            var newSize: CGSize
            newSize = CGSize(width: 540, height: 540)
            let rect = CGRect(x: 0, y: 0, width: 540, height: 540)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            uiImage.draw(in: rect)
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, isCaptured: $isCaptured)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
