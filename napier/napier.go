package main

import (
    "fmt"
    "math/rand"
    "time"
)

func count_upto_one() int {
    s := rand.NewSource(time.Now().UnixNano())
    r := rand.New(s)
    counter := 0
    accumurated := 0.0
    for true {
        accumurated += r.Float64()
        counter += 1
        if accumurated > 1.0 {
            break
        }
    }
    return counter
}

func main() {
    fmt.Println("Start")
    n_trial := int(1e8)
    total_count := 0
    for i := 0; i < n_trial; i++ {
        total_count += count_upto_one()
    }
    fmt.Println("napier=", float64(total_count)/float64(n_trial))
}
