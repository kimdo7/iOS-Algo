import Cocoa

class Node{
   var next     : Node?
   var value    : String
   var from    : String
   var priority : Int
   
   init(from: String, value: String, priority : Int) {
      self.next     = nil
      self.from     = from
      self.value    = value
      self.priority = priority
   }
}

class PriorityQueue{
   var head : Node?
   init(){
      self.head = nil
   }
   
   func insert(from:String, value : String, priority: Int) -> Self{
      let newNode = Node(from: from, value: value, priority: priority)
      guard var runner = head else{
         head = newNode
         return self
      }
      
      while let next = runner.next   {
         if next.priority < priority{
            runner = next
         }else{
            break
         }
      }
      
      if runner === head && runner.priority > priority{
         newNode.next = head
         head = newNode
      }else{
         newNode.next = runner.next
         runner.next = newNode
      }
      
      return self
   }
   
   func display(){
      guard var runner = head else{return}
      
      while(runner.next != nil){
         print("{\(String(describing: runner.value)), \(String(describing: runner.priority))}")
         if let nextNode = runner.next{
            runner = nextNode
         }
      }
      print("{\(runner.value), \(runner.priority)}")
   }
   
   func update(from: String, value : String , priority: Int) -> Self{
      guard var runner = self.head else {return self}
      
      while let next = runner.next{
         if next.value != value{
            runner = next
         }else{
            break
         }
      }
      
      runner.next = runner.next?.next
      insert(from: from, value: value, priority: priority)
      
      return self
   }
   
   
   func remove() -> Node{
      if let runner = self.head{
         head = runner.next
         return runner
      }
      
      return Node(from: "None", value: "None", priority: -1)
   }
}

//func PQT(){
//   let priorityQueue = PriorityQueue()
//   priorityQueue.insert(value: "a", priority: 5)
//
//   priorityQueue.insert(value: "b", priority: 3)
//   priorityQueue.insert(value: "c", priority: 7)
//   priorityQueue.insert(value: "d", priority: 1)
//   priorityQueue.display()
//
//   print("Update b to 4")
//   priorityQueue.update(value: "e", priority: 4)
//   //priorityQueue.update(value: "a", priority: 10)
//   //priorityQueue.display()
//   //priorityQueue.update(value: "a", priority: 2)
//   priorityQueue.display()
//}


//let graph : [String : [Any]] = [
//   "A" : [("B",2), ("C",3)],
//   "B" : [("A",2), ("C",4)]//, ("E",20), ("D",20)],
////   "C" : [("A",3), ("B",4), ("E",2)],
////   "E" : [("C",2), ("D",10)],
////   "D" : [("B", 20), ("E",10)]
//   ]




let map : [String : [(String, Int)]] = [
   "A" : [("B",6), ("D",1)],
   "B" : [("A", 6), ("D",2), ("E", 2), ("C",5)],
   "C" : [("B",5), ("E",5)],
   "D" : [("A",1), ("B",2), ("E",1)],
   "E" : [("D",1), ("B",2), ("C",5)]
]


func find(list: [String], item:String) -> Int{
   for i in 0 ..< list.count{
      if list[i] == item{
         return i
      }
   }
   
   return -1
}


class Graph{
   var visted : [String] = []
   var unvisited : [String] = []
   var tracker : [String:(Int,String)] = [:]
   var graph : [String : [(String, Int)]] = [:]
   var origin : String = ""
   
   init(graph :[String : [(String, Int)]], origin: String ) {
      tracker["A"] = (0,"")
      for key in graph.keys{
         unvisited.append(key)
      }
      
      self.graph = graph
      self.origin = origin
   }
   
   func shortestPath () -> [String:(Int,String)]{
      _djPath(graph: self.graph, origin: self.origin)
      return tracker
   }
   
   func _djPath(graph: [String:[(String, Int)]], origin: String){
      
      if unvisited.isEmpty{
         return
      }
      
      let currPos = tracker[origin]?.0
      let priority = PriorityQueue()
      
      if let currPots = graph[origin]{
         for pot in currPots{
            if !visted.contains(pot.0){
               if !tracker.keys.contains(pot.0){
                  tracker[pot.0] = (pot.1 + currPos!,origin)
               }else if (pot.1 + currPos!) < tracker[pot.0]!.0{
                  tracker[pot.0] = (pot.1 + currPos!,origin)
               }
               priority.insert(from: origin, value: pot.0, priority: pot.1)
            }
            
         }
      }
      
      let nextNode = priority.remove()
      
      let unvistedPos = find(list: unvisited, item: origin)
      visted.append(origin)
      unvisited.remove(at: unvistedPos)
      
      _djPath(graph: graph, origin: nextNode.value)
   }
   
}

let graph = Graph(graph: map, origin: "A")
print(graph.shortestPath())


