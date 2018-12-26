//
//  BandDataSource.swift
//  Fusion
//
//  Created by Charles Imperato on 12/23/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

class BandDataSource {
    
    // - Fetches band member info
    func fetchBand(_ onSuccess: @escaping (_ members: [Member]) -> (), _ onFailure: @escaping (_ error: String) -> ()) {
        let request = MembersRequest()
        
        request.sendRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .error(let error):
                        log.error("Unable to fetch the band members. \(error)")
                        onFailure(error.localizedDescription)

                    case .success(let data):
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let membersJson = json["members"] {
                                let members = try JSONDecoder.init().decode([Member].self, from: try JSONSerialization.data(withJSONObject: membersJson))
                                onSuccess(members)
                            }
                            else {
                                onFailure(JSONError.notFound.localizedDescription)
                            }
                        }
                        catch {
                            onFailure(error.localizedDescription)
                        }
                }
            }
        }
    }
}
