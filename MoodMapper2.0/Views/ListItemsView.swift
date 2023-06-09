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
                HStack{
                    Text(currentItem.emoji)
                        .font(.title2)
                    Text(currentItem.description)
                        .font(.title)
                    Spacer()
                }
            }
            .onDelete(perform: removeRows)
        }
    }
    
    init(filteredOn searchText: String){
        _moodMappers = BlackbirdLiveModels({
            db in
            try await MoodMapper.read(from: db, sqlWhere: "description LIKE ?", "%\(searchText)%")
        })
    }
    
    func removeRows(at offsets: IndexSet){
        Task{
            
            try await db!.transaction{ core in
                var idList = ""
                for offset in offsets{
                    idList += "\(moodMappers.results[offset].id),"
                }
                print(idList)
                idList.removeLast()
                print(idList)
                
                try core.query("DELETE FROM MoodMapper WHERE id IN (?)",idList)
            }
            
        }
    }

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsView(filteredOn: "")
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
}
