//
//  File.swift
//  
//
//  Created by YUJIN JEON on 3/21/24.
//

import Foundation

public struct User: Identifiable, Codable {
    public var id: String
    public var nickName: String
    public var address: String
    public var image: String?
    public var point: Int?
    public var myBooks: [String]? //북정보를 가지고 있음
    public var rentalBooks: [String]? //렌탈정보를 가지고 있음

    public init(id: String, nickName: String, address: String, image: String? = nil, point: Int? = 0, myBooks: [String]? = nil, rentalBooks: [String]? = nil) {
        self.id = id
        self.nickName = nickName
        self.address = address
        self.image = image
        self.point = point
        self.myBooks = myBooks
        self.rentalBooks = rentalBooks
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.nickName = try container.decode(String.self, forKey: .nickName)
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? "주소 정보 없음"
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.myBooks = try container.decodeIfPresent([String].self, forKey: .myBooks) ?? []
        self.rentalBooks = try container.decodeIfPresent([String].self, forKey: .rentalBooks) ?? []
    }
    
    //샘플
    public static var sample: User {
        User(id: "", nickName: "호스표", address: "경기도 양주시")
    }
}

public enum UserCodingKeys: String, CodingKey {
    case id, address
    case nickName = "nickname"
    case image
    case price
    case pointUserID
    case myBooks
    case rentalBooks
}


