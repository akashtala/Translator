//
//  TokenProvider.swift
//  Pods
//
//  Created by Akash Tala on 02/08/25.
//


import Foundation

class TokenProvider {
    func generateToken(text: String) -> String {
        return tokenGen(text)
    }
    
    private func tokenGen(_ a: String) -> String {
        let tkk = TKK()
        
        let b: Int = 406398
        var d: [Int] = []
        let codeUnits = a.unicodeScalars.map { Int($0.value) }
        
        var f = 0
        while f < codeUnits.count {
            var g = codeUnits[f]
            
            if g < 128 {
                d.append(g)
            } else if g < 2048 {
                d.append((g >> 6) | 192)
                d.append((g & 63) | 128)
            } else if (g & 0xFC00) == 0xD800 && f + 1 < codeUnits.count && (codeUnits[f + 1] & 0xFC00) == 0xDC00 {
                
                g = 0x10000 + ((g & 0x3FF) << 10) + (codeUnits[f + 1] & 0x3FF)
                f += 1
                d.append((g >> 18) | 240)
                d.append((g >> 12) & 63 | 128)
                d.append((g >> 6) & 63 | 128)
                d.append(g & 63 | 128)
            } else {
                d.append((g >> 12) | 224)
                d.append((g >> 6) & 63 | 128)
                d.append(g & 63 | 128)
            }
            f += 1
        }
        
        var aInt = b
        for e in d {
            aInt += e
            aInt = wr(aInt, "+-a^+6")
        }
        aInt = wr(aInt, "+-3^+b+-f")
        aInt ^= tkk[1] as? Int ?? 0
        
        if aInt < 0 {
            aInt = (aInt & 0x7FFFFFFF) + 0x80000000
        }
        
        aInt = aInt % 1_000_000
        return "\(aInt).\(aInt ^ b)"
    }
    
    private func TKK() -> [Any] {
        return ["406398", 561666268 + 1526272306]
    }
    
    private func wr(_ a: Int, _ b: String) -> Int {
        var aInt = a
        let bArray = b.unicodeScalars.map { String($0) }
        var c = 0
        
        while c < bArray.count - 2 {
            let dStr = bArray[c + 2]
            let d: Int
            if dStr.unicodeScalars.first?.value ?? 0 >= "a".unicodeScalars.first!.value {
                d = Int(dStr.unicodeScalars.first!.value) - 87
            } else {
                d = Int(dStr)!
            }
            
            let shifted = bArray[c + 1] == "+" ? unsignedRightShift(aInt, d) : aInt << d
            aInt = bArray[c] == "+" ? (aInt + shifted) & 0xFFFFFFFF : aInt ^ shifted
            
            c += 3
        }
        return aInt
    }
    
    private func unsignedRightShift(_ a: Int, _ b: Int) -> Int {
        var shift = b
        var value = a
        
        if shift >= 32 || shift < -32 {
            let m = shift / 32
            shift -= m * 32
        }
        if shift < 0 {
            shift += 32
        }
        if shift == 0 {
            return ((value >> 1) & 0x7FFFFFFF) * 2 + ((value >> shift) & 1)
        }
        
        if value < 0 {
            value = (value >> 1) & 0x7FFFFFFF
            value |= 0x40000000
            value = value >> (shift - 1)
        } else {
            value = value >> shift
        }
        
        return value
    }
}
