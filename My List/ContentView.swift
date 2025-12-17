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
    
    @State private var isPresentingAddSheet = false
    @State private var newTitle: String = ""
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(items){ item in
                    NavigationLink {
                        ItemDetailView(item: item)
                    } label: {
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.isCompleted ? .green : .secondary)
                            Text(item.title)
                                .strikethrough(item.isCompleted, color: .secondary)
                                .foregroundStyle(item.isCompleted ? .secondary : .primary)
                        }
                    }
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
            .listStyle(.insetGrouped)
            .navigationTitle("Grocery List")
            .toolbar{
                // Keep the fun carrot only when empty (optional)
                if items.isEmpty{
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            // nothing
                        }label: {
                            Image(systemName: "cart")
                        }
                    }
                }
            }
            .overlay{
                if items.isEmpty{
                    ContentUnavailableView("Empty Cart", systemImage: "cart.circle", description: Text("Add some items to the shopping list!"))
                }
            }
            // Fixed bottom button that does not scroll with the list
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 0) {
                    // A subtle separator above the button
                    Divider()
                    Button {
                        newTitle = ""
                        isPresentingAddSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Item")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                }
            }
            .sheet(isPresented: $isPresentingAddSheet) {
                NavigationStack {
                    Form {
                        Section("Title") {
                            TextField("e.g. Apples", text: $newTitle)
                                .textInputAutocapitalization(.words)
                                .submitLabel(.done)
                                .onSubmit(saveNewItemIfPossible)
                        }
                    }
                    .navigationTitle("New Item")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { isPresentingAddSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") { saveNewItemIfPossible() }
                                .disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
    }
    
    private func saveNewItemIfPossible() {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let item = Item(title: trimmed, isCompleted: false)
        modelContext.insert(item)
        isPresentingAddSheet = false
        newTitle = ""
    }
}

private struct ItemDetailView: View {
    @Bindable var item: Item
    
    var body: some View {
        Form {
            Section("Title") {
                TextField("Title", text: $item.title)
                    .textInputAutocapitalization(.words)
            }
            Section {
                Toggle("Completed", isOn: $item.isCompleted)
            }
        }
        .navigationTitle("Edit Item")
        .navigationBarTitleDisplayMode(.inline)
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
