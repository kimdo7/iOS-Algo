import Cocoa

var orgList = [5121, 22,45,17,101, 36,84,77, 133]

func radixSort(list: [Int]) -> [Int]{
   return _radixSort(list: list, base: 10)
}

func _radixSort(list: [Int], base: Int) -> [Int]{
   var next = false
   var baseList : [[Int]] = [[],[],[],[],[],[],[],[],[],[]]
   
   for num in list{
      if num > base{
         next = true
      }
      
      let pos = (num % base) / (base / 10)
      baseList[pos].append(num)
      
   }
   
   if next {
      return _radixSort(list: Array(baseList.joined()), base: base * 10)
   }
   
   return Array(baseList.joined())
}

print(radixSort(list: orgList))
