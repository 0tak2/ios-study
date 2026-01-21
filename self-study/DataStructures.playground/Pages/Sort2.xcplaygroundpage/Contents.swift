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

var arr = [1, 5, 3, 2, 4]
quickSort(of: &arr)
print(arr)


//: [Next](@next)
