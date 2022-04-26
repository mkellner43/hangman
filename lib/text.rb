# frozen_string_literal: true

module Message
  def messages(message)
    {
      'start_message' => 'We are starting a new game of hangman! Try to guess the word below. Each blank line represents a letter in the word.',
      'guess' => "\nGuess a letter between a-z :\n",
      'invalid_guess' => "\nplease enter one letter between a and z that hasn\'t already been guessed (:\n\n",
      'load_or_new' => "\n Press 1 to start a new game or 2 to load a saved game:\n",
      'invalid_game_start' => 'invalid response, enter 1 or 2 :',
      'correct_guess' => "\n\nYou've guessed a letter from the secret word!",
      'incorrect_guess' => "\nGood try, but that letter is not in the word :(\n\n",
      'guesses_left' => "Number of wrong guesses: #{@turn_count}. You have #{8 - @turn_count} more guesses until you lose!",
      'winner' => 'YOU HAVE WON!',
      'display_word' => "\nYou've guessed the word \"#{@display_arr.join}\" correct!\n\n",
      'lost' => 'You have lost!',
      'replay' => 'Would you like to play again? y / n',
      'guessed' => "\nLetter's already guessed: #{@guessed.join(', ')}\n\n"
    }[message]
  end
end
