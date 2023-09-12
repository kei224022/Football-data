//
//  APIManager.swift
//  Football-data
//
//  Created by member on 2023/09/12.
//

import Foundation
import Combine

class APIManager {
    let baseURL = "https://api.football-data.org/v2/"
    let apiKey = "2c5b5879922b4abca85d3c3a35eb955a"

    static let shared = APIManager()

    func fetchCompetitions(completion: @escaping (Result<[Competition], Error>) -> Void) {
        let url = URL(string: "\(baseURL)competitions")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let competitionsResponse = try decoder.decode(CompetitionsResponse.self, from: data)
                completion(.success(competitionsResponse.competitions))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchStandings(competitionId: Int, completion: @escaping (Result<[Standing], Error>) -> Void) {
        let url = URL(string: "\(baseURL)competitions/\(competitionId)/standings")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let standingsResponse = try decoder.decode(StandingsResponse.self, from: data)
                if let overallStandings = standingsResponse.standings.first(where: { $0.type == "TOTAL" }) {
                    completion(.success(overallStandings.table))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Standings not found"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchMatches(competitionId: Int, completion: @escaping (Result<[Match], Error>) -> Void) {
        let url = URL(string: "\(baseURL)competitions/\(competitionId)/matches")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let matchesResponse = try decoder.decode(MatchesResponse.self, from: data)
                completion(.success(matchesResponse.matches))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    func fetchTeams(completion: @escaping (Result<[Team], Error>) -> Void) {
        let url = URL(string: "\(baseURL)teams")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Auth-Token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let teamsResponse = try decoder.decode(TeamsResponse.self, from: data)
                completion(.success(teamsResponse.teams))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    // 以下に他のエンドポイント用の関数を追加します
}

struct TeamsResponse: Codable {
    let teams: [Team]
}

struct StandingsResponse: Codable {
    let standings: [Table]

    struct Table: Codable {
        let type: String
        let table: [Standing]
    }
}

struct Standing: Codable, Identifiable {
    let id = UUID()
    let position: Int
    let team: Team
    let points: Int

    enum CodingKeys: String, CodingKey {
        case position
        case team
        case points
            }
}

struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let crestUrl: String
}

struct CompetitionsResponse: Codable {
    let competitions: [Competition]
}

struct Competition: Codable, Identifiable {
    let id: Int
    let name: String
}

struct MatchesResponse: Codable {
        let matches: [Match]
    }

struct Match: Codable, Identifiable {
    let id: Int
    let homeTeam: Team
    let awayTeam: Team
    let utcDate: Date
    let score: Score

    struct Team: Codable {
        let id: Int
        let name: String
    }

    struct Score: Codable {
        let fullTime: FullTime

        struct FullTime: Codable {
            let homeTeam: Int?
            let awayTeam: Int?
        }
    }
}


