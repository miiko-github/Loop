//
//  ShareService.swift
//  Loop
//
//  Created by Nate Racklyeft on 7/2/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import Foundation
import ShareClient


// Encapsulates the Dexcom Share client service and its authentication
struct ShareService: ServiceAuthentication {
    var credentials: [ServiceCredential]

    let title: String = NSLocalizedString("Dexcom Share", comment: "The title of the Dexcom Share service")

    init(username: String?, password: String?) {
        credentials = [
            ServiceCredential(
                title: NSLocalizedString("Username", comment: "The title of the Dexcom share username credential"),
                placeholder: nil,
                isSecret: false,
                keyboardType: .asciiCapable,
                value: username
            ),
            ServiceCredential(
                title: NSLocalizedString("Password", comment: "The title of the Dexcom share password credential"),
                placeholder: nil,
                isSecret: true,
                keyboardType: .asciiCapable,
                value: password
            )
        ]

        if let username = username, let password = password {
            isAuthorized = true
            client = ShareClient(username: username, password: password)
        }
    }

    // The share client, if credentials are present
    private(set) var client: ShareClient?

    var username: String? {
        return credentials[0].value
    }

    var password: String? {
        return credentials[1].value
    }

    var isAuthorized: Bool = false

    mutating func verify(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let username = username, let password = password else {
            completion(false, nil)
            return
        }

        let client = ShareClient(username: username, password: password)
        client.fetchLast(1) { (error, _) in
            completion(true, error)
        }
        self.client = client
    }

    mutating func reset() {
        credentials[0].value = nil
        credentials[1].value = nil
        isAuthorized = false
        client = nil
    }
}
