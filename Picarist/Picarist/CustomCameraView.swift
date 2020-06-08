import SwiftUI
import AVFoundation

struct CustomCameraView: View {
    @Binding var showingCustomCamera: Bool
    @Binding var inputImage: UIImage?
    @Binding var isCaptured: Bool
    @State var didTapCapture: Bool = false
    @State var imagePickerPresented: Bool  = false

    var body: some View {
        VStack() {
            CustomCameraRepresentable(image: $inputImage, didTapCapture: $didTapCapture, isCaptured: $isCaptured)
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "photo")
                    .font(.system(size: 40))
                    .padding(.leading, 30)
                    .frame(width: 100, alignment: .leading)
                    .onTapGesture {
                        self.imagePickerPresented.toggle()
                    }
                    Spacer()
                    CaptureButtonView()
                    .onTapGesture {
                        self.didTapCapture = true
                    }
                    Spacer()
                    Image(systemName: "camera.rotate")
                    .font(.system(size: 40))
                    .padding(.trailing, 30)
                    .frame(width: 100, alignment: .trailing)
                }
                .padding(.bottom, 100)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $imagePickerPresented) {
            ImagePicker(image: self.$inputImage, isCaptured: self.$isCaptured)
        }
    }
}

struct CaptureButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 70, height: 70)
            Circle()
                .fill(Color.white)
                .frame(width: 60, height: 60)
        }
    }
}
