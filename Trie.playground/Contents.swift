import UIKit



class Node{
   var letters : [Character: Node]
   var isWord : Bool

   init() {
      letters = [Character:Node]()
      isWord = false
   }
   
   func display(str: String) -> [String]{
      var result : [String] = []
      self._findAll(node: self, str: str, results: &result)
      return result
   }
   
   func _findAll(node : Node, str : String, results : inout [String]){
      if node.isWord == true{
         results.append(str)
      }
      
      for key in node.letters.keys{
         _findAll(node: node.letters[key]!, str: str +  String(key), results: &results)
      }
   }
}

class Trie{
   var root : Node
   init(){
      root = Node()
   }

   func add(str: String){
      var runner = root
      for key in str{

         if let next = runner.letters[key]{
            runner = next
         }
         else{
            let newNode = Node()
            runner.letters[key] = newNode
            runner = newNode
         }
      }
      runner.isWord = true
   }

   func autoComplete(str : String) -> [String]{
      var runner = root

      for key in str{
         if let next = runner.letters[key]{
            runner = next
         }else{
            return []
         }
      }
      
      return runner.display(str: str)
   }
   
   func showAllOptions() -> [String]{
      return root.display(str: "")
   }
   
}

var trie  = Trie()
trie.add(str: "Dog")
trie.add(str: "cat")
trie.add(str: "catch")
trie.add(str: "catholics")

print("Should print [cat, catch, catholics]: " , trie.autoComplete(str: "ca"))
print("Should print [cat, catch, catholics]: " , trie.autoComplete(str: "cat"))
print("Should print [catch]: " , trie.autoComplete(str: "catc"))
print("Should print [catholics]: " , trie.autoComplete(str: "cath"))

//print("\nShow all options: " , trie.showAllOptions())
