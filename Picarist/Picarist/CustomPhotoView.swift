import SwiftUI

struct CustomPhotoView: View {
    @Binding var inputImage: UIImage?
    @Binding var isCaptured: Bool
//    let model = saved_model()
    
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
                    .onTapGesture {
//                        self.testModel()
                    }
                    .padding(.trailing, 30)
                    .frame(width: 100, alignment: .trailing)

                }
                .padding(.bottom, 100)
            }
        }
    }
    
//    func testModel() {
//        do {
//            print(inputImage!.size)
//            let result = try model.prediction(input_2: inputImage!.pixelBuffer(width: 256, height: 256)!)
//            inputImage = result.Identity.image(min: 0, max: 255, axes: (3, 1, 2))
//        }
//        catch {
//            print("error")
//        }
//    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: image.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
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
