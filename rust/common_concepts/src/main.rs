fn main() {
    variables_and_mutability();
    data_types();
    functions_example();
    control_flow_example();
    ownership_example();
    references_and_borrowing_example();
    slices_example();
}

// 1. Variables and Mutability
fn variables_and_mutability() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}

// 2. Data Types
fn data_types() {
    // Integer
    let x: i32 = 42;
    println!("x: {}", x);

    // Floating-point
    let y: f64 = 3.14;
    println!("y: {}", y);

    // Boolean
    let is_active: bool = true;
    println!("is_active: {}", is_active);

    // Character
    let letter = 'A';
    println!("letter: {}", letter);
}

// 3. Functions
fn functions_example() {
    let result = add(5, 3);
    println!("5 + 3 = {}", result);
}

fn add(a: i32, b: i32) -> i32 {
    a + b
}

// 4. Control Flow
fn control_flow_example() {
    if_statement_example();
    loop_example();
    while_example();
    for_example();
}

fn if_statement_example() {
    let number = 6;

    if number % 2 == 0 {
        println!("The number is even");
    } else {
        println!("The number is odd");
    }
}

fn loop_example() {
    let mut count = 0;
    loop {
        count += 1;
        println!("Count is: {}", count);
        if count == 3 {
            break;
        }
    }
}

fn while_example() {
    let mut number = 3;

    while number != 0 {
        println!("{}", number);
        number -= 1;
    }
    println!("LIFTOFF!!!");
}

fn for_example() {
    let arr = [10, 20, 30, 40, 50];
    for element in arr.iter() {
        println!("Element is: {}", element);
    }
}

// 5. Ownership
fn ownership_example() {
    let s1 = String::from("hello");
    let s2 = s1;

    println!("{}", s2); // s1 is no longer valid here
}

// 6. References and Borrowing
fn references_and_borrowing_example() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1);
    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}

// 7. Slices
fn slices_example() {
    let s = String::from("hello world");
    let hello = &s[0..5];
    let world = &s[6..11];

    println!("First slice: {}", hello);
    println!("Second slice: {}", world);
}
