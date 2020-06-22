import SwiftUI
import CoreML

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
                        Text("Van gogh!")
                        .font(.system(size: 15))
                    }
                    .onTapGesture {
                        let model = StarryStyle()
                        let styleArray = try? MLMultiArray(shape: [1] as [NSNumber], dataType: .double)
                        var unstyleArray = styleArray!
                        unstyleArray[0] = 1.0
                        if let image = self.pixelBuffer(from: self.inputImage!) {
                            do {
                                let predictionOutput = try model.prediction(image: image, index: styleArray!)
                
                                let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                                let tempContext = CIContext(options: nil)
                                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
                               // Image(uiImage: inputImage!)
                                self.inputImage = UIImage(cgImage: tempImage!)
                               // self.imageView.image = UIImage(cgImage: tempImage!)
    } catch let error as NSError {
        print("CoreML Model Error: \(error)")
    }
}
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
    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        // 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 256, height: 256), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
     
        // 2
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 256, 256, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
           
        // 3
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
           
        // 4
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 256, height: 256, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
           
        // 5
        context?.translateBy(x: 0, y: 256)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 6
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            
        return pixelBuffer
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
