//
//  BookingHIstoryCell.swift
//  Dripdoctors
//
//  Created by mac on 8/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class BookingHIstoryCell: UIView {
    var imgBGCell : UIImageView!
    var imgServLogo : UIImageView!
    var lblServName : UILabel!
    var lblPrice : UILabel!
//    var lblBookingStatus : UILabel!
    var lblAddress : UILabel!
    var lblCallType : UILabel!
    var lblBookingTime : UILabel!
    var lblOverviewTitle : UILabel!
    var vwRatingBackground : UIView!
    var btnOptions : UIButton!
    var imgNursePhoto : UIImageView!
    var vwNurseNameBg : UIView!
    var lblNurseName : UILabel!
    var imgReview1 : UIImageView!
    var imgReview2 : UIImageView!
    var imgReview3 : UIImageView!
    var imgReview4 : UIImageView!
    var imgReview5 : UIImageView!
    var vwDetail : UIView!
    var btnApplyAgain : UIButton!
    var btnReportNurse : UIButton!
    var btnAskRefund : UIButton!
    var btnRemove :UIButton!
    
    var index :Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let vwWidth = frame.size.width
        let vwHeight = frame.size.height
        
        imgBGCell = UIImageView(frame: CGRectMake(0, 3, vwWidth, vwHeight - 5))
        imgBGCell.backgroundColor = UIColor.whiteColor()
        
        imgServLogo = UIImageView(frame: CGRectMake(16, 5, 60, 60))
        
        lblServName = UILabel(frame: CGRectMake(80, 8, vwWidth - 210, 20))
        
        lblPrice = UILabel(frame:CGRectMake(80, 30, vwWidth - 210, 20))
        
//        lblBookingStatus = UILabel(frame: CGRectMake(vwWidth - 136,))
        lblBookingTime = UILabel(frame: CGRectMake(16, 75, vwWidth - 152,15))
        lblCallType = UILabel(frame: CGRectMake(16, 95,vwWidth - 152, 15))
        lblAddress = UILabel(frame: CGRectMake(16, 115,vwWidth - 152, 15))
        lblOverviewTitle = UILabel(frame: CGRectMake(16, 135,vwWidth - 152, 15))
        btnOptions = UIButton(frame: CGRectMake(vwWidth - 132, 16,112, 30))
        imgNursePhoto = UIImageView(frame: CGRectMake(vwWidth - 136, 50,120, 120))
        vwNurseNameBg = UIView(frame: CGRectMake(vwWidth - 132, 170,112, 30))
        lblNurseName = UILabel(frame: CGRectMake(vwWidth - 132, 16,112, 30))
        
        vwRatingBackground = UIView(frame:  CGRectMake(16, 170,112, 30))
//        let im1Rect CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
