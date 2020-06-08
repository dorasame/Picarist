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
                        VStack {
                            Image(systemName: "return")
                            .font(.system(size: 30))
                            Text("뒤로")
                            .font(.system(size: 15))
                        }
                        .font(.system(size: 30))
                    }
                    .padding(.leading, 30)
                    .frame(width: 100, alignment: .leading)
                    Spacer()
                    SaveButtonView()
                    .onTapGesture {
                        self.saveImage()
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "square.and.pencil")
                        .font(.system(size: 30))
                        Text("편집")
                        .font(.system(size: 15))
                    }
                    .padding(.trailing, 30)
                    .frame(width: 100, alignment: .trailing)

                }
                .padding(.bottom, 100)
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
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.white)
        }
    }
}
