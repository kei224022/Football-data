//
//  SearchView.swift
//  Football-data
//
//  Created by member on 2023/09/12.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults = [Team]()

    var body: some View {
        VStack {
            TextField("Search for a team...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List(searchResults) { team in
                Text(team.name)
            }
            .onAppear {
                APIManager.shared.fetchTeams { result in
                    switch result {
                    case .success(let teams):
                        DispatchQueue.main.async {
                            self.searchResults = teams
                        }
                    case .failure(let error):
                        print("Error fetching teams: \(error)")
                    }
                }
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
