use std::ops::RangeInclusive;

advent_of_code::solution!(4);

pub fn part_one(input: &str) -> Option<u32> {
    let result = input
        .lines()
        .filter(|line| {
            let vec: Vec<_> = line.split(',').collect();
            let range1 = get_range(vec[0]);
            let range2 = get_range(vec[1]);
            return includes(&range1, &range2) || includes(&range2, &range1);
        })
        .count();
    Some(result as u32)
}

fn get_range(input: &str) -> RangeInclusive<u32> {
    let vec: Vec<_> = input.split('-').collect();
    let start = vec[0].parse::<u32>().unwrap();
    let end = vec[1].parse::<u32>().unwrap();
    start..=end
}

fn includes(first: &RangeInclusive<u32>, last: &RangeInclusive<u32>) -> bool {
    first.start() <= last.start() && first.end() >= last.end()
}

pub fn part_two(input: &str) -> Option<u32> {
    let result = input
        .lines()
        .filter(|line| {
            let vec: Vec<_> = line.split(',').collect();
            let range1 = get_range(vec[0]);
            let range2 = get_range(vec[1]);
            return overlaps(&range1, &range2);
        })
        .count();
    Some(result as u32)
}

fn overlaps(first: &RangeInclusive<u32>, last: &RangeInclusive<u32>) -> bool {
    first.start() <= last.end() && first.end() >= last.start()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let result = part_one(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(2));
    }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(4));
    }
}
