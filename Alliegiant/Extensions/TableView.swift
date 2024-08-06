//
//  TableView.swift
//  Alliegiant
//
//  Created by P10 on 06/08/24.
//

import Foundation
import UIKit

extension UITableView {
    func exportInvoiceAsPDF(headerInfo: [String: String]) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Alliegiant Inc.",
            kCGPDFContextAuthor: "Your Name"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11.0 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let pdfData = pdfRenderer.pdfData { (context) in
            context.beginPage()
            
            // Draw custom content
            drawHeader(context: context, headerInfo: headerInfo, pageRect: pageRect)
            
            // Adjust content offset and draw table view
            let originalOffset = contentOffset
            let originalFrame = frame
            let originalBounds = bounds
            
            contentOffset = .zero
            frame = CGRect(origin: .zero, size: contentSize)
            bounds = CGRect(origin: .zero, size: contentSize)
            
            let contentFrame = CGRect(x: 20, y: 150, width: pageRect.width - 40, height: contentSize.height)
            context.cgContext.translateBy(x: 0, y: 150)
            layer.render(in: context.cgContext)
            context.cgContext.translateBy(x: 0, y: -150)
            
            contentOffset = originalOffset
            frame = originalFrame
            bounds = originalBounds
        }
        
        return pdfData
    }
    
    private func drawHeader(context: UIGraphicsPDFRendererContext, headerInfo: [String: String], pageRect: CGRect) {
        let companyName = headerInfo["companyName"] ?? "Company Name"
        let userName = headerInfo["userName"] ?? "User Name"
        let userNumber = headerInfo["userNumber"] ?? "User Number"
        let amount = headerInfo["amount"] ?? "Amount"
        
        // Set font
        let textFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        
        // Draw Company Name
        let companyNameAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont
        ]
        let companyNameString = NSAttributedString(string: companyName, attributes: companyNameAttributes)
        companyNameString.draw(at: CGPoint(x: 20, y: 20))
        
        // Draw User Name
        let userNameAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont
        ]
        let userNameString = NSAttributedString(string: "Name: \(userName)", attributes: userNameAttributes)
        userNameString.draw(at: CGPoint(x: 20, y: 60))
        
        // Draw User Number
        let userNumberAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont
        ]
        let userNumberString = NSAttributedString(string: "\(userNumber)", attributes: userNumberAttributes)
        userNumberString.draw(at: CGPoint(x: 20, y: 100))
        
        // Draw Amount
        let amountAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont
        ]
        let amountString = NSAttributedString(string: "\(amount)", attributes: amountAttributes)
        amountString.draw(at: CGPoint(x: pageRect.width - 220, y: 20))
    }
}
