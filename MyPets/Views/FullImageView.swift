//
//  FullImageView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI

struct FullImageView: View {
    let imageUrl: String
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            /*ZoomableScrollView(scale: $scale, lastScale: $lastScale, offset: $offset, lastOffset: $lastOffset)*/
            VStack {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private var content: Content
    @Binding private var scale: CGFloat
    @Binding private var lastScale: CGFloat
    @Binding private var offset: CGSize
    @Binding private var lastOffset: CGSize
    
    init(scale: Binding<CGFloat>, lastScale: Binding<CGFloat>, offset: Binding<CGSize>, lastOffset: Binding<CGSize>, @ViewBuilder content: () -> Content) {
        self._scale = scale
        self._lastScale = lastScale
        self._offset = offset
        self._lastOffset = lastOffset
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 5
        scrollView.minimumZoomScale = 1
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = true
        hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostedView.frame = scrollView.bounds
        scrollView.addSubview(hostedView)
        
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        return scrollView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, hostingController: UIHostingController(rootView: content))
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController.rootView = content
        
        if uiView.zoomScale != scale {
            uiView.zoomScale = scale
        }
        
        let offsetX = max((uiView.bounds.width - uiView.contentSize.width) * 0.5, 0) + offset.width
        let offsetY = max((uiView.bounds.height - uiView.contentSize.height) * 0.5, 0) + offset.height
        uiView.contentOffset = CGPoint(x: -offsetX, y: -offsetY)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ZoomableScrollView
        var hostingController: UIHostingController<Content>
        
        init(parent: ZoomableScrollView, hostingController: UIHostingController<Content>) {
            self.parent = parent
            self.hostingController = hostingController
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            parent.scale = scrollView.zoomScale
        }
        
        func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            parent.lastScale = scale
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
            let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
            
            let newOffset = CGSize(
                width: scrollView.contentOffset.x + offsetX,
                height: scrollView.contentOffset.y + offsetY
            )
            
            parent.offset = newOffset
            parent.lastOffset = newOffset
        }
        
        @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
            let scrollView = recognizer.view as! UIScrollView
            let pointInView = recognizer.location(in: hostingController.view)
            
            let newZoomScale = scrollView.zoomScale > scrollView.minimumZoomScale
                ? scrollView.minimumZoomScale
                : scrollView.maximumZoomScale
            
            let scrollViewSize = scrollView.bounds.size
            let width = scrollViewSize.width / newZoomScale
            let height = scrollViewSize.height / newZoomScale
            let x = pointInView.x - (width / 2.0)
            let y = pointInView.y - (height / 2.0)
            
            let rectToZoomTo = CGRect(x: x, y: y, width: width, height: height)
            scrollView.zoom(to: rectToZoomTo, animated: true)
        }
    }
}

struct FullImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullImageView(imageUrl: "https://example.com/cat1.jpg")
    }
}
