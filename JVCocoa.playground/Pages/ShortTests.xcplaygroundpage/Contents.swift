// Playground - noun: a place where people can play


let test:[Int]? = [12345]
let object:Any = test

let mirror  = Mirror.init(reflecting: object)

print(mirror.displayStyle)
