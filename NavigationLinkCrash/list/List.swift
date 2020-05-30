//
//  ItemsList.swift
//  NavigationLinkCrash
//
//  Created by José Manuel Sánchez Peñarroja on 30/05/2020.
//  Copyright © 2020 sculptedapps. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct ItemsList: Equatable {
	var items: IdentifiedArrayOf<Item> = []
	var selected: UUID?
}

enum ListAction {
	case add
	case detail(UUID, DetailAction)
}

let listReducer = Reducer<ItemsList, ListAction, Env> { state, action, env in
	switch action {
	case .add:
		state.items.append(Item(
			id: env.uuid(),
			name: "My item \(state.items.count)")
		)
	case let .detail(id, .select(true)):
		state.selected = id
	case let .detail(id, .select(false)):
		state.selected = nil
	case let .detail(id, .remove):
		if state.selected == id {
			state.selected = nil
		}
		state.items.remove(id: id)
	case .detail:
		break
	}
	
	return .none
}

let appReducer = Reducer<ItemsList, ListAction, Env>.combine(
	detailReducer.forEach(
			state: \.items,
			action: /ListAction.detail,
			environment: { $0 }
	),
	listReducer
)

struct ListView: View {
	var store: Store<ItemsList, ListAction>
	
	var body: some View {
		NavigationView {
			WithViewStore(self.store) { viewStore in
				VStack {
				List {
					ForEachStore(self.store.scope(
						state: \.items,
						action: ListAction.detail
					)) { itemStore in
						WithViewStore(itemStore) { itemViewStore in
							
							NavigationLink(
								destination: DetailView(store: itemStore),
								isActive: itemViewStore.binding(
									get: { $0.id == viewStore.selected },
									send: DetailAction.select
								)
							) {
								Text(itemViewStore.name)
							}
						}
					}
				}.frame(width: 200, height: 200)
				
				Button(action: {
					viewStore.send(.add)
				}) {
					Text("Add")
				}
				}
			}
		}
	}
}
