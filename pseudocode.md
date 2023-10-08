Class: MastermindGame
  Constants:
    - BALLS: ['r', 'g', 'o', 'y', 'v', 'm'] (constant array)

  Initialize:
    - Initialize instance variables:
      - @combinations: Call possible_combinations method
      - @computer_code: Call generate_code method
      - @player_code: Empty array
      - @counter: 1
      - @player_role: Call select_player_role method

  select_player_role:
    - Display "Do you want to be the Code Breaker (B) or the Code Maker (M)?"
    - Get user input and store it in 'role'
    - Loop until 'role' is 'b' or 'm':
      - Display "Please enter 'B' for Code Breaker or 'M' for Code Maker."
      - Get user input and store it in 'role'
    - Return 'role' as a lowercase string

  generate_code:
    - Create an empty array 'code'
    - Repeat 4 times:
      - Add a random element from BALLS to 'code'
    - Return 'code'

  player_selection:
    - Create an empty array 'guess'
    - Loop until 'guess' has 4 elements:
      - Display "Please select a color from: (r, g, o, y, v, m):"
      - Get user input and store it in 'value' (as lowercase)
      - If 'value' is in BALLS:
        - Add 'value' to 'guess'
      - Else:
        - Display "Selection not in the combination, try again"
    - Return 'guess' as an array of 4 colors

  possible_combinations:
    - Calculate 'total_combinations' as length of BALLS raised to the power of 4
    - Create an empty array 'combinations'
    - Repeat 'total_combinations' times using 'i':
      - Create an empty array 'combination'
      - Repeat 4 times using 'j':
        - Calculate 'index' as (i divided by (length of BALLS raised to the power of j)) modulo length of BALLS
        - Add BALLS[index] to 'combination'
      - Add 'combination' to 'combinations'
    - Return 'combinations'

  computer_selection:
    - Return a random element from '@combinations'

  compare_arrays(computer, player):
    - Initialize 'exact_match' and 'color_match' as 0
    - Iterate through 'computer' and 'player' in parallel with 'letter' and 'index':
      - If 'letter' in 'computer' matches 'letter' in 'player' and their positions are the same:
        - Increment 'exact_match' by 1
      - Else if 'letter' in 'player' exists in 'computer':
        - Increment 'color_match' by 1
    - Return an array [exact_match, color_match]

  play:
    - If '@player_role' is 'b':
      - Call play_as_code_breaker method
    - Else:
      - Call play_as_code_maker method

  play_as_code_breaker:
    - Loop while '@counter' is less than or equal to 12:
      - Display "Turn #{@counter}:"
      - Set '@player_code' to the result of 'player_selection'
      - Call 'compare_arrays' with '@computer_code' and '@player_code' and store the result in 'match'
      - If 'match' is [4, 0]:
        - Display "Congratulations! You guessed the code."
        - Exit loop
      - Else:
        - Display "Incorrect guess. Keep trying."
        - Display "Exact match: #{match[0]},  Color match: #{match[1]}"
      - Increment '@counter' by 1
    - Display "Game Over! You have reached the maximum number of turns."
    - Display "The code is #{@computer_code}"

  play_as_code_maker:
    - Display "You are the Code Maker. Please create a 4-color secret code."
    - Set '@computer_code' to the result of 'player_selection'
    - Display "Code created. Now, let the computer try to guess it."
    - Loop while '@counter' is less than or equal to 12:
      - Display "Turn #{@counter}:"
      - Set '@player_code' to the result of 'computer_selection'
      - Call 'compare_arrays' with '@computer_code' and '@player_code' and store the result in 'match'
      - If 'match' is [4, 0]:
        - Display "The computer guessed your code! You lose."
        - Exit loop
      - Else:
        - Display "The computer did not guess your code."
        - Display "Exact match: #{match[0]},  Color match: #{match[1]}"
      - Call 'play_cases' with 'match'
      - Increment '@counter' by 1
    - Display "Game Over! The computer could not guess your code."
    - Display "The code is #{@computer_code}"

  play_cases(match):
    - Case 'match':
      - When [0, 0]:
        - Remove combinations from '@combinations' where any letter in '@player_code' is included
      - When [0, 4], [1, 3], [2, 2]:
        - Select combinations in '@combinations' where all letters in '@player_code' are included
      - Else:
        - Select combinations in '@combinations' where any letter in '@player_code' is included
