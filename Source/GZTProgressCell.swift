//
//  GZTProgressCell.swift
//  edX
//
//  Created by 童罡正 on 2/20/16.
//  Copyright © 2016 edX. All rights reserved.
//

import UIKit

class GZTProgressCell: UITableViewCell {
    
    var myLabel1: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        
        let view = GZTProgressView()
        
        contentView.addSubview(view)

        let labelHeight: CGFloat = 30
       // let labelWidth: CGFloat = view.frame.width;
        myLabel1 = UILabel()
        myLabel1.frame = CGRectMake(0, 10, 380, labelHeight)
        myLabel1.textColor = UIColor.blackColor()
        myLabel1.text = "Progress"
        myLabel1.textAlignment = NSTextAlignment.Center
        
        contentView.addSubview(myLabel1)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
