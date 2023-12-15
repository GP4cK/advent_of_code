use std::collections::HashMap;

advent_of_code::solution!(2);

const ROCK: u32 = 1;
const PAPER: u32 = 2;
const SCISSORS: u32 = 3;

pub fn part_one(input: &str) -> Option<u32> {
    let mut sign_map: HashMap<&str, u32> = HashMap::new();
    sign_map.insert("A", ROCK);
    sign_map.insert("B", PAPER);
    sign_map.insert("C", SCISSORS);
    sign_map.insert("X", ROCK);
    sign_map.insert("Y", PAPER);
    sign_map.insert("Z", SCISSORS);

    let lines = input.lines();
    let mut score = 0;
    for line in lines {
        let vec: Vec<_> = line.split(' ').collect();
        let player1 = sign_map.get(&vec[0]).unwrap();
        let player2 = sign_map.get(&vec[1]).unwrap();
        score += get_score(player1, player2);
    }
    Some(score)
}

pub fn part_two(input: &str) -> Option<u32> {
    let mut sign_map: HashMap<&str, u32> = HashMap::new();
    sign_map.insert("A", ROCK);
    sign_map.insert("B", PAPER);
    sign_map.insert("C", SCISSORS);

    let lines = input.lines();
    let mut score = 0;
    for line in lines {
        let vec: Vec<_> = line.split(' ').collect();
        let sign = sign_map.get(&vec[0]).unwrap();
        let outcome = vec[1];
        score += match outcome {
            "X" => lose(sign) + LOST,
            "Y" => draw(sign) + DRAW,
            "Z" => win(sign) + WIN,
            _ => panic!("Invalid input"),
        };
    }
    Some(score)
}

const LOST: u32 = 0;
const DRAW: u32 = 3;
const WIN: u32 = 6;

fn get_score(player1: &u32, player2: &u32) -> u32 {
    if *player1 == *player2 {
        return player2 + DRAW;
    }
    if *player2 == ROCK {
        match *player1 {
            PAPER => return ROCK + LOST,
            SCISSORS => return ROCK + WIN,
            _ => return ROCK + DRAW,
        }
    }
    if *player2 == PAPER {
        match *player1 {
            SCISSORS => return PAPER + LOST,
            ROCK => return PAPER + WIN,
            _ => return PAPER + DRAW,
        }
    }
    if *player2 == SCISSORS {
        match *player1 {
            ROCK => return SCISSORS + LOST,
            PAPER => return SCISSORS + WIN,
            _ => return SCISSORS + DRAW,
        }
    }
    panic!("Invalid input");
}

fn win(sign: &u32) -> u32 {
    match *sign {
        ROCK => return PAPER,
        PAPER => return SCISSORS,
        SCISSORS => return ROCK,
        _ => panic!("Invalid input"),
    }
}

fn lose(sign: &u32) -> u32 {
    match *sign {
        ROCK => return SCISSORS,
        PAPER => return ROCK,
        SCISSORS => return PAPER,
        _ => panic!("Invalid input"),
    }
}

fn draw(sign: &u32) -> u32 {
    match *sign {
        ROCK => return ROCK,
        PAPER => return PAPER,
        SCISSORS => return SCISSORS,
        _ => panic!("Invalid input"),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(15));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(12));
    }
}
