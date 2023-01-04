//
//  1000.swift
//  BaekJoon_Swift
//
//  Created by 제임스 on 2022/11/03.
//

import Foundation

let line = readLine()!
let lineArray = line.components(separatedBy: " ")
let x = Int(lineArray[0])
let y = Int(lineArray[1])

if x! < 0 || y! > 10{
    print("out of range")
    exit(0)
}

let result = x! + y!

print(result)
