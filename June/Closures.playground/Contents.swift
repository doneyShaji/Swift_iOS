import UIKit

func grabLunch(message: String, search: ()->()) {
   print(message)
   search()
}

// use of trailing closure
grabLunch(message:  {
  print("Alfredo's Pizza: 2 miles away")
}
