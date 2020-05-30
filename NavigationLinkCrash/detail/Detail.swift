//
//  Detail.swift
//  NavigationLinkCrash
//
//  Created by José Manuel Sánchez Peñarroja on 30/05/2020.
//  Copyright © 2020 sculptedapps. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct Item: Equatable, Identifiable {
	var id: UUID
	var name: String
}

enum DetailAction {
	case rename(String)
	case remove
	case select(Bool)
}

let detailReducer = Reducer<Item, DetailAction, Env> { state, action, env in
	switch action {
	case let .rename(name):
		state.name = name
	case .remove, .select:
		break
	}
	
	return .none
}

struct DetailView: View {
	var store: Store<Item, DetailAction>
	
	var body: some View {
		WithViewStore(self.store) { viewStore in
			VStack {
			HStack {
			TextField("Name: ", text: viewStore.binding(
				get: { $0.name },
				send: DetailAction.rename
			))
			
				Button(action: {
					viewStore.send(DetailAction.remove)
				}) {
					Text("Remove")
				}
			}
			
			Spacer()
				
			}
			.frame(width: 200, height: 200)
		}
	}
}
