from random import randomize, rand

randomize()

proc count_upto_one(): int64 =
  var 
    counter=0
    accumulated=0.0
  while true:
    accumulated += rand(max=1.0) 
    counter += 1 
    if accumulated >= 1.0:
      break 
  return counter

if isMainModule:
  let n_trial = int64(1e8)
  var total_count:int64= 0
  for _ in 1 ..< n_trial:
    total_count += count_upto_one()
  echo total_count.float64 / n_trial.float64