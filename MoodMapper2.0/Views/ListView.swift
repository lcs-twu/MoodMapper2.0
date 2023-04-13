//
//  ListView.swift
//  MoodMapper2.0
//
//  Created by Tom Wu on 2023-04-13.
//

import Blackbird
import SwiftUI

struct ListView: View {
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    
    @State var newEmojiDescription: String = ""
    
    @State var newItemDescription: String = ""
    
    @State var searchText = ""
    var body: some View {
        NavigationView{
            VStack {
                
                ListItemsView(filteredOn: searchText)
                .searchable(text: $searchText)
                
                HStack {
                    TextField("Enter a emoji", text: $newEmojiDescription)
                    TextField("Enter your feeling", text: $newItemDescription)
                    Button(action: {
                        //                        let lastId = todoItems.last!.id
                        //                        let newId = lastId + 1
                        //                        let newTodoItem = TodoItem(id: newId, description: newItemDescription, completed: false)
                        //                        todoItems.append(newTodoItem)
                        //                        newItemDescription = ""
                        
                        //MARK: blackbird check how many ? in for each column
                        Task { try await db!.transaction {
                            core in try core.query("INSERT INTO MoodMapper (description, emoji) VALUES (?,?)",newEmojiDescription, newItemDescription)
                        }
                            newEmojiDescription = ""
                            newItemDescription = ""
                        }
                    }, label: {
                        Text("ADD")
                            .font(.caption)
                    })
                }
                .padding(20)
            }
            .navigationTitle("Mood Mapper")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
