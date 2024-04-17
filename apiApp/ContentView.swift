//
//  ContentView.swift
//  apiApp
//
//  Created by COOPER, ALYSSA J. on 4/15/24.
//

import SwiftUI

// Model representing a user object decoded from JSON
struct User: Codable {
    public var imageUrl: String
    
    // CodingKeys enum maps "url" key in JSON to imageUrl property
    enum CodingKeys: String, CodingKey {
        case imageUrl = "url"
    }
}

struct ContentView: View {
    // UIImage?: UIImage is a class in UIKit that represents an image. In SwiftUI, you often use UIImage to work with images fetched from URLs or stored in the app's bundle. The ? after UIImage indicates that fetchedImage is an optional, meaning it can either hold a valid UIImage object or be nil (i.e., have no value).
    @State var fetchedImage: UIImage? = nil
    
    var body: some View {
        
        ZStack {
            // Fill the entire screen with cyan color, ignoring safe area insets
            Color.cyan.edgesIgnoringSafeArea(.all)
            
            VStack{
                // Display fetched image if available
                if let image = fetchedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                // Button to fetch a duck image when tapped
                Button("Fetch Duck Image") {
                    getImage()
                }.padding()
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .cornerRadius(/*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
            } //VStack
        } //ZStack
    }

    // Function to fetch duck image from API
    func getImage() {
        //guard: The guard statement in Swift is used for early exit from a block of code if a condition isn't met. It's commonly used to check for the validity of optional values or conditions that must be true for the code to proceed. In summary, the guard statement in the provided code snippet checks if a valid URL can be created from the given string. If not, it prints an error message and exits the function, ensuring that the rest of the code is not executed with an invalid URL. If the URL is valid, the code continues execution after the guard statement.
        // Check if URL is valid
        guard let url = URL(string: "https://random-d.uk/api/v2/random") else {
            print("Invalid URL")
            return
        }
        
        // Create a data task to fetch data from URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check for valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            // Check if data is available
            if let data = data {
                do {
                    // Decode JSON data into User object
                    let duckData = try JSONDecoder().decode(User.self, from: data)
                    print("Duck Image URL: \(duckData.imageUrl)")
                    
                    // Create URL from imageUrl string
                    guard let duckImageUrl = URL(string: duckData.imageUrl)
                    else {
                        print("Invalid Duck Image URL")
                        return
                    }
                    
                    // Fetch image data from imageUrl
                    let imageData = try Data(contentsOf: duckImageUrl)
                    
                    // Create UIImage from image data
                    guard let image = UIImage(data: imageData)
                    else {
                        print("Unable to create UIImage from data")
                        return
                    }
                    
                    //DispatchQueue: It allows you to dispatch work to a specific queue, which can run concurrently with other tasks on different queues.
                    //.async { ... }: This method asynchronously dispatches the given closure to the specified queue, which in this case is the main queue. Asynchronous dispatch means that the closure is added to the queue and executed at some point in the future, allowing the current execution flow to continue without waiting for the closure to finish.
                    // Update fetchedImage on the main thread
                    DispatchQueue.main.async {
                        fetchedImage.self = image
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume() // Resume data task
    }
    
}//Content View
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
