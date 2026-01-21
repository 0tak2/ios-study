func bubbleSort(of array: inout [Int]) {
    for i in 0..<array.count {
        for j in 0..<array.count {
            if i == j {
                continue
            }
            
            if array[i] < array[j] {
                let temp = array[i]
                array[i] = array[j]
                array[j] = temp
            }
        }
    }
}

func selectionSort(of array: inout [Int]) {
    for i in 0..<array.count {
        var minIndex = i // 선택
        for j in i+1..<array.count { // 그 다음부터 돌면서 다음 최소값 찾기
            if array[j] < array[minIndex] {
                minIndex = j
            }
        }
        
        let temp = array[i]
        array[i] = array[minIndex]
        array[minIndex] = temp
    }
}

func insertionSort(of array: inout [Int]) {
    for i in 1..<array.count { // 1번째 원소부터 순회
        let temp = array[i] // 현재
        var prev = i - 1
        
        while prev >= 0 && array[prev] > temp { // 이전 원소가 꺼내둔 값과 비교하고 크면
            array[prev + 1] = array[prev] // 뒤로 민다
            prev -= 1
        }
        // 다 밀어넣었으면 마지막 자리에 temp를 둔다
        array[prev + 1] = temp
    }
}

var arr = [1, 5, 3, 2, 4]
//bubbleSort(of: &arr)
//selectionSort(of: &arr)
insertionSort(of: &arr)
print(arr)
