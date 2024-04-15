//
//  ContentView.swift
//  apiApp
//
//  Created by COOPER, ALYSSA J. on 4/15/24.
//

import SwiftUI

// API url  https://api.github.com/search/users?q=greg

// Both structs use Codable so that we can passs them to the JSON Decord to decode the JSON response string back into the structs

// Structs will contain the information returned from the JSON
// NOTE that the variable names have to be exactly like in the JSON file

//individual User from the json
struct User: Codable {
    public var login: String
    public var url: String
    public var avatar_url: String
    public var html_url: String
}

//the items array from the JSON
struct Result: Codable {
    var items: [User]
}

struct ContentView: View {
    @State private var fetchedImage: UIImage? = nil
    var body: some View {
        HStack {
            Button("Generate Ducks") {
                
            }

        }//HStack
        
        VStack{
            if let image = fetchedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            else {
                Button("Fetch Image") {
                    getImage()
                }.padding()
            }
        }
        
    }//struct
    
    func getImage(){
        guard let url = URL(string: "")
        else{
            print("Invalid url")
            return
        }
        URLSession.shared.dataTask(with: url) {data, response error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid response")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.fetchedImage = image
                }
            }
            else {
                print("Invalid image data")
            }
        }.resume()
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
