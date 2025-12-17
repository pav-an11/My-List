//
//  ContentView.swift
//  My List
//
//  Created by student on 17/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    
    @Query private var items: [Item]
    @State private var isAlertShowing: Bool = false
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(items){ item in
                    Text(item.title)
                }
            }
            .navigationTitle("Grocery Items")
            toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        isAlertShowing.toggle()
                    }label:{
                        Image(systemName: "Carrot")
                            .imageScale(.large)
                        
                    }
                }
            }
            overlay{
                if items.isEmpty{
                    ContentUnavailableView("Empty cart", systemImage: "Cart.circle",description: Text("Add some item to the shoping"))
                }
            }
        }
    }
    
}
#Preview("Second List"){
     ContentView()
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
