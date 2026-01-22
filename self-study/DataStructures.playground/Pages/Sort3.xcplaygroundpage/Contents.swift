//: [Previous](@previous)

import Foundation

struct Heap {
  private var storage = [Int]()

  let comparator: (Int, Int) -> Bool

  init(comparator: @escaping (Int, Int) -> Bool) {
    self.comparator = comparator
  }
  
  init() {
    self.init(comparator: { a, b in a < b })
  }

  var isEmpty: Bool {
    self.storage.isEmpty
  }

  var count: Int {
    self.storage.count
  }

  mutating func insert(_ value: Int) {
    storage.append(value)

    shiftUp(from: count - 1)
  }

  mutating func remove() -> Int? {
    guard !isEmpty else { return nil }

    storage.swapAt(0, count - 1) // 첫 값을 삭제해야 함. 우선 첫 값과 마지막 값을 스왑.

    defer {
      shiftDown(from: 0) // return 후에 수행할 작업. 스왑된 값부터 자식과 비교하면서 제 자리를 찾아줌.
    }

    return storage.removeLast()
  }

  mutating func shiftDown(from index: Int) { // 레벨 수 만큼 비교하므로 O(logN)
    var parent = index // 내려갈 시작점
    while true {
      let left = getLeftChildIndex(parentIndex: parent)
      let right = getRightChildIndex(parentIndex: parent)
      var candidate = parent

      if left < count && comparator(storage[left], storage[candidate]) {
        candidate = left
      }

      if right < count && comparator(storage[right], storage[candidate]) { // 여기서 candidate는 부모이거나 왼쪽 형제. 결국 가장 작은 값을 선택해 아래로 내리게 됨.
        candidate = right
      }

      if candidate == parent { // 마지막에 도달한 경우
        return
      }

      storage.swapAt(parent, candidate)
      parent = candidate // 바뀐 위치를 다시 부모로 잡고 반복
    }
  }

  mutating func shiftUp(from index: Int) {
    var child = index
    var parent = getParentIndex(childIndex: child)
    while child > 0 && comparator(storage[child], storage[parent]) { // 레벨 수 만큼 비교하므로 O(logN)
      storage.swapAt(child, parent)
      child = parent // 바뀐 위치를 다시 자식으로 잡고 반복
      parent = getParentIndex(childIndex: child)
    }
  }

  // MARK: - Utils for handling index
  func getLeftChildIndex(parentIndex: Int) -> Int {
    parentIndex * 2 + 1
  }

  func getRightChildIndex(parentIndex: Int) -> Int {
    parentIndex * 2 + 2
  }

  func getParentIndex(childIndex: Int) -> Int {
    (childIndex - 1) / 2
  }
}

func heapSort(of array: inout [Int]) {
  var h = Heap()
  for i in array {
    h.insert(i)
  }
  
  for i in 0..<array.count {
    array[i] = h.remove()!
  }
}

var arr = [1, 5, 3, 2, 4]
heapSort(of: &arr)
print(arr)

//: [Next](@next)
