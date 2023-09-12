//
//  LeagueDetailView.swift
//  Football-data
//
//  Created by member on 2023/09/12.
//

import SwiftUI

struct LeagueDetailView: View {
    let competition: Competition
    @State private var standings = [Standing]()
    @State private var matches = [Match]()

    var body: some View {
        VStack {
            Text(competition.name)
                .font(.largeTitle)
                .padding()
            
            //
            
            TabView{
                VStack{
                    List(standings){ standing in
                        HStack{
                            Text("\(standing.position)")
                                .frame(width: 25)
                            
                            Text(standing.team.name)
                            
                            Spacer()
                            
                            Text("\(standing.points) pts")
                        }
                    }
                    .onAppear{
                        APIManager.shared.fetchStandings(competitionId: competition.id){ result in
                            switch result{
                            case .success(let standings):
                                DispatchQueue.main.async{
                                    self.standings = standings
                                }
                            case .failure(let error):
                                print("Error fetching standiongs: \(error)")
                            }
                        }
                    }
                }
                .tabItem{
                    Image(systemName: "list.number")
                    Text("Standings")
                }
                
                VStack{
                    List(matches) { match in
                        VStack(alignment: .leading){
                            Text("\(match.homeTeam.name) vs \(match.awayTeam.name)")
                            
                            Text("\(match.utcDate, formatter: dateFormatter)")
                        }
                    }
                    .onAppear{
                        APIManager.shared.fetchMatches(competitionId: competition.id) { result in
                            switch result {
                            case .success(let matches):
                                DispatchQueue.main.async {
                                    self.matches = matches
                                }
                            case .failure(let error):
                                print("Error fetching matches: \(error)")
                            }
                        }
                    }
                }
                .tabItem{
                    Image(systemName: "calendar")
                    Text("Matches")
                }
                
                //
                SearchView()
                    .tabItem{
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
            }
            // 順位表と試合日程の表示に関連するビューコードをここに追加します
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()


struct LeagueDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueDetailView(competition: Competition(id: 2022, name: "Premier League"))
    }
}
