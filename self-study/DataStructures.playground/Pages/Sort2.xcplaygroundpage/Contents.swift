//: [Previous](@previous)

func quickSortPartition(array: inout [Int], start: Int, end: Int) -> Int {
    let pivot = array[start]
    
    var left = start + 1
    var right = end
    
    while left <= right {
        while left <= end && array[left] < pivot {
            left += 1 // 왼쪽에서 피벗보다 작은 값이 나오면 한 칸 이동
        }
        while right > start && array[right] > pivot {
            right -= 1 // 오른쪽에서 피벗보다 큰 값이 나오면 한 칸 이동
        }
        
        if left < right { // 한 번 더 검사
            // 여기서 교차되지 않았다면, 각각은 피벗보다 큰 값, 피벗보다 작은 값을 가리키고 있음
            // 서로 바꾼다.
            let temp = array[left]
            array[left] = array[right]
            array[right] = temp
            
            left += 1
            right -= 1
        }
    }
    
    // 피벗과 right 스왑
    let temp = array[start]
    array[start] = array[right]
    array[right] = temp
    
    return right
}

func quickSort(of array: inout [Int], start: Int = 0, end: Int = -1) {
    let end = end == -1 ? array.count - 1 : end
    if start < end {
        let pivot = quickSortPartition(array: &array, start: start, end: end)
        
        quickSort(of: &array, start: start, end: pivot - 1)
        quickSort(of: &array, start: pivot + 1, end: end)
    }
}

var arr = [1, 5, 3, 2, 4]
quickSort(of: &arr)
print(arr)

//: [Next](@next)
