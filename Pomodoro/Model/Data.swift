//
//  Data.swift
//  Pomodoro
//
//  Created by 金一成 on 2020/10/6.
//

import Foundation
import RealmSwift


class Data:Object{
    @objc dynamic var name = ""
    @objc dynamic var leftTime = 30
}
