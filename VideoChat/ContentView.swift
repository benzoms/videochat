//
//  ContentView.swift
//  VideoChat
//
//  Created by Ben Zhang on 6/3/21.
//

import SwiftUI
import Foundation
import Combine



struct RequestMenu: Codable {
    var data: [CallRequest] = Array()
}
struct CallRequest: Codable{
    public var username: String
    public var lastName: String
    public var firstName: String
    public var scheduledTime: String
    public var price: Int
    public var profileURL: String
}

struct DataMenu: Codable {
    var id = UUID()
    //var data = [String: [String]]()
    var data: [CallRequestID] = Array()
}

struct CallRequestID: Codable, Identifiable{

    public var id = UUID()
    public var formattedDate: Date?
    public var displayDate: String
    public var cr: CallRequest

    init(tempcr: CallRequest) {
        self.cr = tempcr
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "M/dd/yy H:mma"
        
        if let date = dateFormatterGet.date(from: cr.scheduledTime) {
            self.displayDate = (dateFormatterPrint.string(from: date))
            self.formattedDate = date
        } else {
           print("There was an error decoding the string")
            self.displayDate = ""
            
        }


    }
}


class FetchToDo: ObservableObject {

    @Published var todos = DataMenu()

     var str: String = "poo"

     
    init() {
        let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let todoData = data {
                
                    DispatchQueue.main.async {
                        self.str = String(decoding: todoData, as: UTF8.self)
                        let jsonData = self.str.data(using: .utf8)!
                        do {
                          let decoder = JSONDecoder()

                          let tableData = try decoder.decode(RequestMenu.self, from: jsonData)
                            //print(tableData)
                            //print("Current # of requests: \(tableData.data.count)")
                            tableData.data.forEach { request in
                                  //print(request.username)
                            var dv = CallRequestID(tempcr: request)
                            self.todos.data.append(dv)
                                
                                
                              }

                        }
                        catch {
                          print (error)
                        }
                    }

                } else {
                    print("No data")
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

struct ContentView: View {
    @ObservedObject var fetch = FetchToDo()
    
    var body: some View {
        VStack {
            let str = String(fetch.todos.data.count)
            
            NavigationView {
                
                List {
                        ForEach(fetch.todos.data) { request in
                            VStack(alignment: .leading) {
                                HStack(spacing: 25) {
                                    Text(request.cr.username)
                                        //.foregroundColor(Color.gray)
                                    Text(request.displayDate)
                                        .font(.system(size: 16))
                                    let pricestr: String = String(request.cr.price)
                                    Text("$" + pricestr)
                                        .foregroundColor(Color.red)
                                        .font(.system(size: 14))
                                    
                                }
                                
                                Text("\(request.cr.firstName + " " + request.cr.lastName)")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(Color.gray)
                            }
                            
                                    
                        
                    }
                    
                .navigationTitle("Calls - " + str)
            }
            
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



