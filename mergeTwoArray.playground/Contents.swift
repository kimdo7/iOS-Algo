import Cocoa
extension Array {
   func split() -> [[Element]] {
      let size = self.count
      let half = size / 2
      let leftSplit = self[0 ..< half]
      let rightSplit = self[half ..< size]
      return [Array(leftSplit), Array(rightSplit)]
   }
}

func _merge(leftArr: [Int], rightArr: [Int]) -> [Int]{
   var smallPos = 0
   var bigPos = 0
   var newArr : [Int] = []
   var smallerArray : [Int] = rightArr
   var biggerArray  : [Int] = leftArr
   
   if leftArr.count < rightArr.count{
      smallerArray = leftArr
      biggerArray  = rightArr
   }
   
   for _ in 0..<leftArr.count + rightArr.count{
      if smallPos == smallerArray.count{
         newArr.append(biggerArray[bigPos])
         bigPos += 1
      }else if bigPos == biggerArray.count || smallerArray[smallPos] <= biggerArray[bigPos] {
         newArr.append(smallerArray[smallPos])
         smallPos += 1
      }
      else{
         newArr.append(biggerArray[bigPos])
         bigPos += 1
      }
   }
   
   return newArr
}


func mergeSort(list: [Int]) -> [Int]{
   let left  = list.split().first!
   let right = list.split().last!
   
   if right.count == 1{
      return _merge(leftArr: left, rightArr: right)
   }
   
   return _merge(leftArr: mergeSort(list: left), rightArr: mergeSort(list: right))
}

var arr = [2,17,1,4 ,3,20,55,6,7,54,0,99]
print(mergeSort(list: arr))
