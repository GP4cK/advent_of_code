use itertools::Itertools;
use std::collections::{HashMap, HashSet};

advent_of_code::solution!(3);

pub fn part_one(input: &str) -> Option<u32> {
    let lines = input.lines();
    let mut sum = 0;
    for line in lines {
        let half = line.len() / 2;
        let first = &line[..half];
        let mut set = HashSet::new();
        for char in first.chars() {
            set.insert(char);
        }
        let second = &line[half..];
        for char in second.chars() {
            if set.contains(&char) {
                let prio = if char.is_uppercase() {
                    char as u32 - 'A' as u32 + 27
                } else {
                    char as u32 - 'a' as u32 + 1
                };

                sum += prio;
                break;
            }
        }
    }
    Some(sum)
}

pub fn part_two(input: &str) -> Option<u32> {
    let lines = input.lines();
    let mut sum = 0;
    for (line1, line2, line3) in lines.tuples() {
        let mut map = HashMap::new();
        for char in line1.chars() {
            map.insert(char, 1);
        }
        for char in line2.chars() {
            let count = map.get(&char);
            if count.is_some() {
                map.insert(char, 2);
            }
        }
        for char in line3.chars() {
            let count = map.get(&char);
            if *count.unwrap_or(&0) == 2 {
                sum += get_score(char);
                break;
            }
        }
    }

    Some(sum)
}

fn get_score(c: char) -> u32 {
    if c.is_uppercase() {
        c as u32 - 'A' as u32 + 27
    } else {
        c as u32 - 'a' as u32 + 1
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(157));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(70));
    }
}
