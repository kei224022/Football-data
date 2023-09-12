//
//  ContentView.swift
//  Football-data
//
//  Created by member on 2023/09/12.
//

import SwiftUI

struct ContentView: View {
    @State private var competitions = [Competition]()

    var body: some View {
        NavigationView {
                    List {
                        NavigationLink("Premier League", destination: LeagueDetailView(competition: Competition(id: 2021, name: "Premier League")))
                        NavigationLink("La Liga", destination: LeagueDetailView(competition: Competition(id: 2014, name: "La Liga")))
                        NavigationLink("Bundesliga", destination: LeagueDetailView(competition: Competition(id: 2002, name: "Bundesliga")))
//                        NavigationLink("J-League", destination: LeagueDetailView(competition: Competition(id: 2019, name: "J-League")))
                    }
                    .navigationTitle("Leagues")
                }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

