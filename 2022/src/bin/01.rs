advent_of_code::solution!(1);

pub fn part_one(input: &str) -> Option<u32> {
    let lines = input.lines();
    let mut elves: Vec<u32> = Vec::new();
    let mut calories = 0;
    for line in lines {
        match line.parse::<u32>() {
            Ok(n) => calories += n,
            Err(_) => {
                elves.push(calories);
                calories = 0;
            }
        };
    }
    elves.push(calories);
    elves.iter().max().cloned()
}

pub fn part_two(input: &str) -> Option<u32> {
    let lines = input.lines();
    let mut elves: Vec<u32> = Vec::new();
    let mut calories = 0;
    for line in lines {
        match line.parse::<u32>() {
            Ok(n) => calories += n,
            Err(_) => {
                elves.push(calories);
                calories = 0;
            }
        };
    }
    elves.push(calories);
    elves.sort();
    elves.reverse();
    Some(elves[0] + elves[1] + elves[2])
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(24000));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(45000));
    }
}
