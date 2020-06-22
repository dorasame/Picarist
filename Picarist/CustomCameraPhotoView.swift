import SwiftUI

struct CustomCameraPhotoView: View {
    @Binding var showingCustomCamera: Bool
    @Binding var inputImage: UIImage?
    @Binding var isCaptured: Bool

    var body: some View {
        Group {
            if !isCaptured {
                CustomCameraView(showingCustomCamera: $showingCustomCamera, inputImage: $inputImage, isCaptured: $isCaptured)
            }
            else {
                CustomPhotoView(inputImage: $inputImage, isCaptured: $isCaptured)
            }
        }
    }
}

