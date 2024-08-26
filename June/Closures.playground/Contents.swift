import UIKit

// How Closures Work?
var doubleAmount: (Int) -> (Int) = { number in
        return number + number
}
let result = doubleAmount(5)
print(result)


// Consice Swift Closure Example

    var array = [6, 4, 6, 2, 8, 3, 0]
    var sorted = array.sorted(by: < )
    print(sorted)

    // Different ways to define the above closures
        //A) First, when we expand < it becomes this:
        var sortedA = array.sorted(by: { (s1: Int, s2: Int) -> Bool in
            return s1 < s2
        })
        print(sortedA)

        //B) Another way to write the same expression
        var sortedB = array.sorted(by: {s1, s2 in
            s1 < s2
        })
        print(sortedB)

        //C) With shorthand operators
        var sortedC = array.sorted(by: {$0 < $1} )
        print(sortedC)

        //D) With trailing closure syntax
        var sortedD = array.sorted { $0 < $1 }
        print(sortedD)

        //E) And finally, you can also just use the < operator as a function:
        var sortedE = array.sorted(by: < )
        print(sortedE)


// Completion handler

let myCompletionHandler: (String) -> () = { done in
        print("The status is \(done)")
}

//Function Block

func checkCompletionHandler(foreign completion: (String) -> ()){
    for i in 1...5 {
        print(i)
    }
    completion("Done")
}

//Calling

checkCompletionHandler(foreign: myCompletionHandler)
