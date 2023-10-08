class MastermindGame
  BALLS = %w[r g o y v m].freeze

  def initialize
    @combinations = possible_combinations
    @computer_code = generate_code
    @player_code = []
    @counter = 1
    @player_role = select_player_role
  end

  def select_player_role
    puts 'Do you want to be the Code Breaker (B) or the Code Maker (M)?'
    role = gets.chomp.downcase
    until %w[b m].include?(role)
      puts 'Please enter "B" for Code Breaker or "M" for Code Maker.'
      role = gets.chomp.downcase
    end
    role
  end

  def generate_code
    code = []
    4.times { code << BALLS.sample }
    code
  end

  def player_selection
    guess = []

    until guess.length == 4
      puts "Please select a color from: (#{BALLS.join(', ')}):"
      value = gets.chomp.downcase

      BALLS.include?(value) ? guess << value : puts('Selection not in the combination, try again')
    end

    guess
  end

  def possible_combinations
    total_combinations = BALLS.length**4
    combinations = []

    total_combinations.times do |i|
      combination = []
      4.times do |j|
        index = (i / BALLS.length**j) % BALLS.length
        combination << BALLS[index]
      end
      combinations << combination
    end

    combinations
  end

  def computer_selection
    @combinations.sample
  end

  def compare_arrays(computer, player)
    exact_match = 0
    color_match = 0

    computer.each_with_index do |letter, index|
      if letter == player[index]
        exact_match += 1
      elsif player.include?(letter)
        color_match += 1
      end
    end

    [exact_match, color_match]
  end

  def play
    if @player_role == 'b'
      play_as_code_breaker
    else
      play_as_code_maker
    end
  end

  def play_as_code_breaker
    while @counter <= 12
      puts "Turn #{@counter}:"
      @player_code = player_selection
      match = compare_arrays(@computer_code, @player_code)

      if match[0] == 4
        puts 'Congratulations! You guessed the code.'
        return
      else
        puts 'Incorrect guess. Keep trying.'
        puts "Exact match: #{match[0]},  Color match: #{match[1]}"
      end

      @counter += 1
    end

    puts 'Game Over! You have reached the maximum number of turns.'
    puts "The code is #{@computer_code}"
  end

  def play_as_code_maker
    puts 'You are the Code Maker. Please create a 4-color secret code.'
    @computer_code = player_selection
    puts 'Code created. Now, let the computer try to guess it.'

    while @counter <= 12
      puts "Turn #{@counter}:"
      @player_code = computer_selection
      pp @player_code

      match = compare_arrays(@computer_code, @player_code)

      if match[0] == 4
        puts 'The computer guessed your code! You lose.'
        return
      else
        puts 'The computer did not guess your code.'
        puts "Exact match: #{match[0]},  Color match: #{match[1]}"
      end

      play_cases(match)
      @counter += 1
    end

    puts 'Game Over! The computer could not guess your code.'
    puts "The code is #{@computer_code}"
  end

  def play_cases(match)
    case match
    when [0, 0]
      @combinations.reject! do |combination|
        combination.any? { |letter| @player_code.include?(letter) }
      end
    when [0, 4], [1, 3], [2, 2]
      @combinations.select! do |combination|
        combination.all? { |letter| @player_code.include?(letter) }
      end
    else
      @combinations.select! do |combination|
        combination.any? { |letter| @player_code.include?(letter) }
      end
    end
  end
end

game = MastermindGame.new
game.play
