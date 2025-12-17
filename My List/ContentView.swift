//
//  ContentView.swift
//  GroceryList
//
//  Created by Teachers on 17/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(items){ item in
                    Text(item.title)
                        .swipeActions{
                            Button(role: .destructive){
                                withAnimation{
                                    modelContext.delete(item)
                                }
                                
                            }label:{
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading){
                            Button("Done", systemImage: item.isCompleted == false ? "checkmark.circle": "x.circle"){
                                item.isCompleted.toggle()
                            }
                            .tint(item.isCompleted == false ? .green : .accentColor)
                        }
                }
            }
            .navigationTitle("Grocery List")
            .toolbar{
                if items.isEmpty{
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            // nothing
                        }label: {
                            Image(systemName: "carrot")
                        }
                    }
                }
            }
            .overlay{
                if items.isEmpty{
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle", description: Text("Add some items to the shopping list!"))
                }
            }
        }
    }
}

#Preview("Sample Data") {
    let sampleData: [Item] = [
        Item(title: "Bakery & Bread", isCompleted: false),
        Item(title: "Meat & Seafood", isCompleted: true),
        Item(title: "Cereals", isCompleted: .random()),
        Item(title: "Pasta & Rice", isCompleted: .random()),
        Item(title: "Cheese & Eggs", isCompleted: .random())
    ]
    
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for item in sampleData {
        container.mainContext.insert(item)
    }
    
    return ContentView()
        .modelContainer(container)
}

#Preview("First List") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

