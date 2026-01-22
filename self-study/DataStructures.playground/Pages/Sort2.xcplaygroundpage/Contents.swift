//: [Previous](@previous)

// MARK: - Quick Sort

func quickSortPartition(array: inout [Int], start: Int, end: Int) -> Int {
    let pivot = array[start] // 첫 값을 피벗으로 사용
    
    var left = start + 1
    var right = end
    
    while left <= right {
        while left <= end && array[left] < pivot {
            left += 1 // 왼쪽에서 피벗보다 큰 값이 나올때 까지 앞으로 이동
        }
        while right > start && array[right] > pivot {
            right -= 1 // 오른쪽에서 피벗보다 작은 값이 나올 때까지 뒤로 이동
        }
        
        if left < right { // 한 번 더 검사
            // 여기서 교차되지 않았다면, 각각은 피벗보다 큰 값, 피벗보다 작은 값을 가리키고 있음
            // 서로 바꾼다.
            let temp = array[left]
            array[left] = array[right]
            array[right] = temp
        }
    }
    
    // 피벗 자리와 지금 right 자리를 바꿔서 피벗을 가운데로 옮기고 그 인덱스를 반환 (새 파티션)
    let temp = array[start]
    array[start] = array[right]
    array[right] = temp
    
    return right
}

func quickSort(of array: inout [Int], start: Int, end: Int) {
    if start < end {
        let pivot = quickSortPartition(array: &array, start: start, end: end)
        quickSort(of: &array, start: start, end: pivot - 1)
        quickSort(of: &array, start: pivot + 1, end: end)
    }
}

func quickSort(of array: inout [Int]) {
  quickSort(of: &array, start: 0, end: array.count - 1)
}

// MARK: - Merge Sort

func merge(of array: inout [Int], temp: inout [Int], start: Int, end: Int, mid: Int) {
  var p1 = start // 왼쪽 파티션 인덱스
  var p2 = mid + 1 // 오른쪽 파티션 인덱스
  var i = start // 결과 배열 인덱스
  
  while p1 <= mid && p2 <= end {
    if array[p1] <= array[p2] {
      temp[i] = array[p1]
      p1 += 1
    } else {
      temp[i] = array[p2]
      p2 += 1
    }
    i += 1
  }
  
  // 남은 값 복사 (두 파티션 중 한 쪽의 원소가 남은 경우)
  // (1) 왼쪽 파티션이 남은 경우 복사
  if p1 <= mid {
      for j in p1...mid {
          temp[i] = array[j]
          i += 1
      }
  }
  
  // (2) 오른쪽 파티션이 남은 경우 복사
  if p2 <= end {
      for j in p2...end {
          temp[i] = array[j]
          i += 1
      }
  }
  
  // 임시배열에서 원래 배열로 복사 (원래 배열 갱신)
  for j in start...end {
    array[j] = temp[j]
  }
}

func mergeSort(of array: inout [Int], temp: inout [Int], start: Int, end: Int) {
  if start < end { // 재귀적으로 호출되다 보면 마지막으로 원소가 두 개인 레인지까지 호출된다
    let mid = (start + end) / 2
    mergeSort(of: &array, temp: &temp, start: start, end: mid)
    mergeSort(of: &array, temp: &temp, start: mid + 1, end: end)
    merge(of: &array, temp: &temp, start: start, end: end, mid: mid)
  }
}

func mergeSort(of array: inout [Int]) {
  var temp = [Int](repeating: 0, count: array.count)
  mergeSort(of: &array, temp: &temp, start: 0, end: array.count - 1)
}

var arr = [1, 5, 3, 2, 4]
//quickSort(of: &arr)
mergeSort(of: &arr)
print(arr)


//: [Next](@next)
