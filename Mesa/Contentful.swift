//
//  Contentful.swift
//  Mesa
//
//  Created by Vibes on 4/27/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import Foundation
import Contentful
import Interstellar

private let queue = DispatchQueue(label: "privateQueue", qos: DispatchQoS.background, attributes: .concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)

var images : [URL: UIImage] = [:]


func getCategories(number : Int, completion : @escaping ([Section]) -> Void )  {
    
    let client: Client = Client(spaceIdentifier: spaces[number], accessToken: tokens[number])

    
    var sections : [Section] = []
    var sortedSections : [Section] = []
    
    var categorySequence = [String] ()
    
    
    /*
     
     let menuQueryParameters = [ "content_type": "menu", "fields.categories.sys.id": "64Ji1DtRrqeKKKUAW8CSIk", "include": 1 ] as [String : Any]
     
     // FETCH ASSETS
     
     client.fetchAssets() { (result: Result<Contentful.Array<Asset>>) in
     switch result {
     case .success(let array):
     let assets = array.items
     
     //            print(assets[0].identifier)
     
     case .error(let error):
     print(error)
     }
     }
     
     // FETCH ALL APPROACH
     
     client.fetchEntries(matching: [ "include": 5 ]) { (result: Result<Contentful.Array<Entry>>) in
     switch result {
     case .success(let array):
     let menuEntriesArray = array.items
     
     let firstMenu = menuEntriesArray[0]
     
     guard let categoryEntriesArray = firstMenu.fields["categories"] as? [Entry] else { return }
     
     for categoryEntry in categoryEntriesArray {
     
     guard let categoryName = categoryEntry.fields["name"] as? String else { return }
     
     print(categoryName)
     
     guard let itemEntriesArray = categoryEntry.fields["items"] as? [Entry] else { return }
     
     //                print(itemEntriesArray)
     
     let items : [Item] = getItemsFromEntries(entries: itemEntriesArray)
     
     //                print(items.count)
     
     }
     
     case .error(let error):
     print(error)
     }
     }
     
     
     
     
     //
     // FETCH ENTRIES MATCHING CONTENT TYPE MENU APPROACH
     //
     //    client.fetchEntries(matching: ["content_type": "menu"]) { (result: Result<Contentful.Array<Entry>>) in
     //
     //        switch result {
     //
     //        case .success(let array):
     //
     //            let entriesOfContentType = array.items
     //
     //            let boo = entriesOfContentType[0]
     //
     //            guard let categorio = boo.fields["categories"] as? [Entry] else { return }
     //
     //            for category in categorio {
     //
     //                guard let categoryName = category.fields["name"] as? String else { return }
     //
     //                print(categoryName)
     //
     //                // Does not return items as an array of entries unfortunately
     //
     //            }
     //
     //
     //
     //        case .error (let error):
     //
     //            print(error)
     //        }
     //
     //
     //    }
     
     // QUERY PARAMETERS APPROACH
     
     let queryParameters = [ "content_type": "menu", "include": 1 ] as [String : Any]
     
     
     client.fetchEntries(matching: queryParameters) { (result: Result<Contentful.Array<Entry>>) in
     switch result {
     case .success(let array):
     
     let menuEntriesArray = array.items
     
     let firstMenu = menuEntriesArray[0]
     
     guard let categoryEntriesArray = firstMenu.fields["categories"] as? [Entry] else { return }
     
     print(categoryEntriesArray.count)
     
     for categoryEntry in categoryEntriesArray {
     
     guard let categoryName = categoryEntry.fields["name"] as? String else { return }
     
     print(categoryName)
     
     }
     
     case .error(let error):
     
     print(error)
     }
     }
     
     */
    
    //  FETCHING SEQUENCE OF CATEGORIES VIA MENU IDENTIFIER
    
    client.fetchEntry(identifier: menus[number]) {(result : Result<Contentful.Entry>) in
        
        switch result {
            
        case .success (let entry) :
            
            guard let categories = entry.fields["categories"] as? [[String:Any]] else { return }
            
            for x in 0..<categories.count {
                
                let category = categories[x]
                guard let cat = category["sys"] as? [String : Any] else { return }
                guard let catID = cat["id"] as? String else { return }
                categorySequence.append(catID)
                
            }
            
        case .error(let error) :
            
            print(error)
            
        }
        
    }
    
    //  FETCHING CATEGORIES IN RANDOM ORDER ALONG WITH ITEMS AND PICTURES

    client.fetchEntries(matching: ["content_type": "category"]) { (result: Result<Contentful.Array<Entry>>) in
        
        switch result {
            
        case .success(let array):
            
            let entriesOfContentType = array.items
            
            for category in entriesOfContentType {
                
                guard let categoryName = category.fields["name"] as? String else { return }
                
                guard let array = category.fields["items"] as? [Entry] else { return }
                
                let items : [Item] = getItemsFromEntries(entries: array)
                
                let section = Section(name: categoryName, items: items, identifier : category.identifier)
                
                sections.append(section)
                
            }
            
            
            for sortedCategoryID in categorySequence {
                
                for section in sections {
                    if section.identifier == sortedCategoryID {
                        sortedSections.append(section)
                    }
                }
                
            }
            
            completion(sortedSections)
            
            
        case .error(let error):
            
            print(error)
        }
        
        
    }
    
}

func getItemsFromEntries ( entries : [Entry] ) -> [Item] {
    
    var items = [Item]()
    
    for item in entries {
        
        guard var name = item.fields["name"] as? String else { return items  }
        
        name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard var details = item.fields["details"] as? String else { return items  }
        
        details = details.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let price = item.fields["price"] as? Double else { return items  }
        
        guard let imageAsset = item.fields["image"] as? Asset else { return items  }
        
        guard let file = imageAsset.fields["file"] as? [String:Any] else { return items   }
        
        guard let url = file["url"] as? String else { return items   }
        
        guard let imageDetails = file["details"] as? [String:Any] else { return items  }
        
        guard let detailsImage = imageDetails["image"] as? [String:Any] else { return items  }
        
        guard let imageHeight = detailsImage["height"] as? Double else { return items }
        
        guard let imageWidth = detailsImage["width"] as? Double else { return items }
        
        var newURL = "https:"+url+"?"
        
        let thumbString = newURL + "w=60&h=60&fit=thumb"
        
        if imageHeight > imageWidth + 50 {
            
            newURL += "w=700"
            
        } else {
            
            newURL += "h=1300"
        }
        
        guard let imageURL = URL(string: newURL) else {  return items  }
        
        guard let thumbURL = URL(string: thumbString) else {  return items  }

        guard let available = item.fields["available"] as? Bool else { return items  }
        
        guard let sale = item.fields["salesToday"] as? Int else { return items  }
        
        let id = item.identifier
        
        let newItem = Item(id: id, name: name, imageURL: imageURL, details: details, price: price, available: available, thumbURL : thumbURL, sale: sale)
        
        items.append(newItem)
        
    }
    
    return items
    
}

public func loadImage(atURL url: URL, completion : @escaping (UIImage) -> Void)  {
    queue.async {
        if let image = images[url] {
            completion(image)
        } else {
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
//                if let newImage = UIImage(data: data!) {
//                    images[url] = newImage
//                    completion(newImage)
//                }
//            }).resume()
            if let data = try? Data(contentsOf: url) {
                if let newImage = UIImage(data: data) {
                    images[url] = newImage
                    completion(newImage)
                }
            }
        }
    }
}

