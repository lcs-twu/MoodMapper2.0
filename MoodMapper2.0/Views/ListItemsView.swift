//
//  ListItemsView.swift
//  MoodMapper2.0
//
//  Created by Tom Wu on 2023-04-13.
//

import Blackbird
import SwiftUI

struct ListItemsView: View {
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @BlackbirdLiveModels var moodMappers: Blackbird.LiveResults<MoodMapper>
    
    var body: some View {
        List{
            
            ForEach(moodMappers.results) { currentItem in
                Label(title: {
                    Text(currentItem.description)
                })
                .onTapGesture {
                    Task {
                        try await db!.transaction {
                            core in try core.query("UPDATE MoodMapper SET completed = (?) WHERE id = (?)", !currentItem.completed, currentItem.id)
                        }
                    }
                }
            }
            
            .onDelete(perform: removeRows)
            
        }
    }
    
    init(filteredOn searchText: String){
        _todoItems = BlackbirdLiveModels({
            db in
            try await TodoItem.read(from: db, sqlWhere: "description LIKE ?", "%\(searchText)%")
        })
    }
    
    func removeRows(at offsets: IndexSet){
        Task{
            
            try await db!.transaction{ core in
                var idList = ""
                for offset in offsets{
                    idList += "\(todoItems.results[offset].id),"
                }
                print(idList)
                idList.removeLast()
                print(idList)
                
                try core.query("DELETE FROM TodoItem WHERE id IN (?)",idList)
            }
        
        }
    }
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsView(filteredOn: "")
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
