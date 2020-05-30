//
//  Env.swift
//  NavigationLinkCrash
//
//  Created by José Manuel Sánchez Peñarroja on 30/05/2020.
//  Copyright © 2020 sculptedapps. All rights reserved.
//

import Foundation

struct Env {
	var uuid: () -> UUID = { UUID() }
}
