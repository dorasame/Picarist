import SwiftUI

struct CustomPhotoView: View {
    @Binding var inputImage: UIImage?
    @Binding var isCaptured: Bool
    
    var body: some View {
        VStack {
            Image(uiImage: inputImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
            Spacer()
            VStack {
                Spacer()
                HStack() {
                    Button(action: {
                        self.isCaptured = false
                    }) {
                        Text("뒤로")
                    }
                    .padding(.leading, 30)
                    Spacer()
                    SaveButtonView()
                    .onTapGesture {
                        self.saveImage()
                    }
                    Spacer()
                    Text("편집")
                    .padding(.trailing, 30)
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(inputImage!, nil, nil, nil)
    }
}

struct SaveButtonView: View {
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
