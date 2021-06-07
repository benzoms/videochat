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
/*var menu = RequestMenu()

func changeDataValue(rm: RequestMenu) {
    menu = rm
    print(2)
   // print(menu)
    print(1)
    print("Current # of requests: \(menu.data.count)")
    menu.data.forEach { menu in
          print(menu.username)
            
      }
}

public func fetchthecall(){
    //var result: RequestMenu = nil
    var result = RequestMenu()
    let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
    URLSession.shared.dataTask(with: url) {(data, response, error) in
        do {
            if let todoData = data {
                let decoder = JSONDecoder()
                let tableData = try decoder.decode(RequestMenu.self, from: todoData)
                //print(tableData)
                print("Rowz in array: \(tableData.data.count)")
                tableData.data.forEach { CallRequest in
                      print(CallRequest.username)
                    print(CallRequest.price)
                    print(CallRequest.username)
                    //result.data.append(CallRequest)
                    //print(result)
                    //print(result.data)
                  }
                DispatchQueue.main.async {
                    result.data = tableData.data
                    changeDataValue(rm: tableData)
                                    }
                
                
            }
            
          
        }
        catch {
          print (error)
        }
        
        //print(result.data)
    }.resume()
    
    //print(result.data)
    //return result
}



struct ContentView: View {
    init() {
            fetchthecall()
        }
    var body: some View {
        
        VStack {
            
            List(menu.data) { todo in
                VStack(alignment: .leading) {
                    
                    Text(todo.username)
                    
                    /*Text("\(todo.completed.description)") // print boolean
                        .font(.system(size: 11))
                        .foregroundColor(Color.gray)*/
                }
            }
            /*List {
                Text(fetch.todos.data[0].username)
            }*/
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
/*func fetchthecall() -> RequestMenu {
    //var result: RequestMenu = nil
    var result = RequestMenu()
    let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
    URLSession.shared.dataTask(with: url) {(data, response, error) in
        do {
            if let todoData = data {
                let decoder = JSONDecoder()
                let tableData = try decoder.decode(RequestMenu.self, from: todoData)
                //print(tableData)
                print("Rowz in array: \(tableData.data.count)")
                tableData.data.forEach { CallRequest in
                      print(CallRequest.username)
                  }
                result = tableData
                
            }
            
          
        }
        catch {
          print (error)
        }
        
    }.resume()
    return result
}


struct ContentView: View {
   
    
    var body: some View {
        NavigationView {
            List {
                
                let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
                URLSession.shared.dataTask(with: url) {(data, response, error) in
                    do {
                        if let todoData = data {
                            let decoder = JSONDecoder()
                            let tableData = try decoder.decode(RequestMenu.self, from: todoData)
                            //print(tableData)
                            print("Rowz in array: \(tableData.data.count)")
                            tableData.data.forEach { CallRequest in
                                  print(CallRequest.username)
                                //result.data.append(CallRequest)
                                //print(result)
                                //print(result.data)
                              }
                            ForEach(menu.data) { request in
                                Text(request.username)
                                
                            }
                            /*DispatchQueue.main.async {
                                result.data = tableData.data
                                changeDataValue(rm: tableData)
                                                }*/
                            
                            
                        }
                        
                      
                    }
                    catch {
                      print (error)
                    }
                    
                    //print(result.data)
                }.resume()
                
                
            }
            .navigationTitle("Menu")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
/*var menu = RequestMenu()

func loadJson() -> RequestMenu{
    
        let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let todoData = data {
                    let decoder = JSONDecoder()
                    let callRequestData = try decoder.decode(RequestMenu.self, from: todoData)
                    
                    menu.data = callRequestData
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
            }
        }.resume()
}*/
/*class FetchCallRequests: ObservableObject {
    @Published var menu = RequestMenu()
     
    init() {
        let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let todoData = data {
                    let decoder = JSONDecoder()
                    let callRequestData = try decoder.decode(RequestMenu.self, from: todoData)
                    
                    DispatchQueue.main.async {
                        self.menu = callRequestData
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
            }
        }.resume()
    }
}

var fetch = FetchCallRequests()
print("Current # of requests: \(fetch.menu.data.count)")
fetch.menu.data.forEach { CallRequest in
      print(CallRequest.username)
  }*/
 
/*class FetchCallRequests: ObservableObject {
    @Published var requests = [CallRequest]()
    
    init() {
            let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        let callRequestData = try decoder.decode([CallRequest].self, from: data)
                        print("HI")
                        DispatchQueue.main.async {
                            self.requests = callRequestData
                        }
                    } else {
                        print("No data")
                    }
                } catch {
                    print("Error")
                }
            }.resume()
        }
}*/

/*struct ContentView: View {
    @ObservedObject var fetch = FetchCallRequests()
    var body: some View {
        VStack {
            List(fetch.requests) { request in
                VStack(alignment: .leading) {
                    Text(request.username)
                    Text("\(request.completed.description)") // print boolean
                        .font(.system(size: 11))
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}*/

/*struct ContentView: View {
    @ObservedObject var fetch = FetchCallRequests()
    
    var body: some View {
        NavigationView {
            List(fetch.menu) { request in
                            VStack(alignment: .leading) {
                                Text(todo.title)
                                Text("\(todo.completed.description)") // print boolean
                                    .font(.system(size: 11))
                                    .foregroundColor(Color.gray)
                            }
                        }
            List{
                ForEach(fetch.menu) { request in
                        Text(request.username)
                    }
            }
            .navigationTitle("Menu")
        }
    }
}*/


/*class FetchRequest: ObservableObject {
    @Published var callrequests = [Request]()
     
    init() {
        let url = URL(string: "https://us-central1-testswiftui-c76c0.cloudfunctions.net/swiftTest")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let requestData = data {
                    let decodedData = try JSONDecoder().decode([Request].self, from: requestData)
                    DispatchQueue.main.async {
                        self.callrequests = decodedData
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
            }
        }.resume()
    }
}*/

/*struct ContentView: View {
    //let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    @ObservedObject var fetch = FetchRequest()
    var body: some View {
        VStack {
            NavigationView {
                List(fetch.callrequests) { request in
                    VStack(alignment: .leading) {
                        
                    }
                    ForEach(fetch.callrequests) { requestitem in
                                Text(requestitem.username)
                            }
                }
            }
            .navigationTitle("Call Requests")
        }
        
    }
}*/

/*struct ContentView: View {
    //let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    @ObservedObject var fetch = FetchRequest()
    var body: some View {
        NavigationView {
            List{
                ForEach(fetch.callrequests) { requestitem in
                            Text(requestitem.username)
                        }
            }
        }
        .navigationTitle("Call Requests")
        
    }
}*/


