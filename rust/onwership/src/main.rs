fn main() {
    demonstrate_move();
    demonstrate_borrowing();
    demonstrate_mutable_borrowing();
    demonstrate_lifetimes();
}

// Move Semantics
fn demonstrate_move() {
    let s1 = String::from("hello");
    let s2 = s1; // s1 is now invalidated; ownership moved to s2
    println!("s2 now owns the string: {}", s2);

    // Attempting to use s1 here would cause a compile error
}

// Borrowing with References
fn demonstrate_borrowing() {
    let s1 = String::from("hello");
    let length = calculate_length(&s1); // s1 is borrowed, not moved
    println!("The length of '{}' is {}", s1, length);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}

// Mutable Borrowing
fn demonstrate_mutable_borrowing() {
    let mut s = String::from("hello");
    modify_string(&mut s); // Borrowing mutably
    println!("Modified string: {}", s);
}

fn modify_string(s: &mut String) {
    s.push_str(", world!");
}

// Lifetime Annotations
fn demonstrate_lifetimes() {
    let string1 = String::from("long string is long");
    let string2 = String::from("short");

    let result = longest(&string1, &string2);
    println!("The longest string is {}", result);
}

// This function takes two string references and returns the longest.
// Lifetime annotations are required to tell Rust how the lifetimes relate.
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
