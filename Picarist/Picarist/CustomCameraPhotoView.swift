import SwiftUI

struct CustomCameraPhotoView: View {
    @Binding var image: Image?
    @Binding var showingCustomCamera: Bool
    @Binding var inputImage: UIImage?
    @Binding var isCaptured: Bool

    var body: some View {
        Group {
            if !isCaptured {
                CustomCameraView(image: $image, showingCustomCamera: $showingCustomCamera, inputImage: $inputImage, isCaptured: $isCaptured)
            }
            else {
                Text("이미지 뷰")
            }
        }
    }
}
