class Poker
  CARDNUM = 52

  class Score
    attr_accessor :cards, :hand, :max_card

    @cards = []
    @hand = 0
    @max_card = 0

    def display
      5.times do |i|
        puts toWord(@cards[i])
      end
    end

    def cardSort
      @cards.sort
    end

    def toWord(num)
      case num/13
      when 0 then
        word = 'spade_'
      when 1 then
        word = 'clover_'
      when 2 then
        word = 'heart_'
      when 3 then
        word = 'diamond_'
      end

      tmp = num % 13
      case tmp
      when 0 then
        word << 'A'
      when 10 then
        word << 'J'
      when 11 then
        word << 'Q'
      when 12 then
        word << 'K'
      else
        word << (tmp+1).to_s
      end

      return word

    end

    def judgeHand
      count = 0
      mark = 0
      different = 0
      j = 0

      4.times do |i|
        for j in i+1..4 do
          if @cards[i] % 13 == @cards[j] % 13 then
            count = count + 1
          end
          if @cards[i] / 13 == @cards[j] /13 then
            mark = mark + 1
          end
        end
      end

      print "-hand : "

      case count
      when 1 then
        puts "one pair"
        @hand = 1
      when 2 then
        puts "two pair"
        @hand = 2
      when 3 then
        puts "three of a kind"
        @hand = 3
      when 4 then
        puts "full house!!"
        @hand = 6
      when 6 then
        puts "four of a kind!!!"
        @hand = 7
      else
        5.times do |i|
          if i != 4 then
            if @cards[i] % 13 + 1 != @cards[i+1] % 13 then
              if i == 0 then
                j = 1
              end
              different = different + 1
            end
          else
            if @cards[i] % 13 - 12 != @cards[0] % 13 then
              different = different + 1
            end
          end
        end

        if different == 1 && mark == 10 && j == 1 then
          puts "royal straight flush!!!!!"
          @hand = 9
        elsif different == 1 && mark == 10 then
          puts "straight flush!!!!"
          @hand = 8
        elsif different == 1 then
          puts "straight!"
          @hand = 4
        elsif mark == 10 then
          puts "flush!"
          @hand = 5
        else
          puts "high cards..."
          @hand = 0
        end
      end

      case @hand
      when 0, 4, 5, 8, 9 then
        if @cards[0]%13 != 0 then
          @max_card = @cards[4] % 13
        else
          @max_card = 0
        end
      when 1, 2, 3, 7 then
        if @cards[0] % 13 == 0 && @cards[1] % 13 == 0 then
          @max_card = 0
        else
          (4..1).reverse_each do |i|
            if @cards[i] %13 == @cards[i-1] % 13 then
              @max_card = @cards[i] % 13
              break
            end
          end
        end
      when 6 then
        count = 0
        2.times do |i|
          if @cards[i] % 13 == @cards[i+1] % 13 then
            count = count + 1
          end
        end
        if count == 1 then
          @max_card = @cards[4] % 13
        else
          @max_card = @cards[0] % 13
        end
      end

      if @max_card == 0 then
        @max_card = 13
      end
    end
  end

  @idx = []
  @action = 0


  def init
    @player = Score.new
    @computer = Score.new
    @idx = []
    @action = 0
    @player.cards = []
    @player.hand = 0
    @player.max_card = 0
    @computer.cards = []
    @computer.hand = 0
    @computer.max_card = 0

    CARDNUM.times do |i|
      @idx << i
    end
  end

  def shuffle
    x = []
    CARDNUM.times do
      x << rand(1024)
    end

    for i in 0..CARDNUM-1 do
      edge = i
      for j in i+1..CARDNUM-1 do
        if x[j] < x[edge] then
          edge = j
        end
        tmp = x[i]
        x[i] = x[edge]
        x[edge] = tmp
        tmp = @idx[i]
        @idx[i] = @idx[edge]
        @idx[edge] = tmp
      end
    end
  end

  def deal
    5.times do |i|
      @player.cards << @idx[i]
      @computer.cards << @idx[i+5]
    end

    setAction()
    puts "<player's cards>"
    @player.display

    puts "\n-Enter \"0\" to next-"
    print "(player) "
    keyWait('0')

  end

  def swap
    choose = 1
    hold = [0, 0, 0, 0, 0]

    @player.cardSort
    @computer.cardSort

    while choose != 0 do
      setAction()
      5.times do |i|
        print "#{i+1} : #{@player.toWord(@player.cards[i])}"
        if hold[i] == 0 then
          puts " - exchange"
        else
          puts " - hold"
        end
      end

      puts "Choose the card number which you want to hold."
      puts "It is finished when you input \"0\"."
      print "(player) "
      choose = gets.to_i
      if choose>0 && choose<=5 then
        hold[choose-1] = ~hold[choose-1]
      end
    end

    5.times do |i|
      if hold[i] == 0 then
        @player.cards[i] = @idx[i+10]
      end
    end

    hold = [0, 0, 0, 0, 0]

    4.times do |i|
      if @computer.cards[i] %13 == @computer.cards[i+1] % 13 then
        hold[i] = 1
        hold[i+1] = 1
      end
    end

    5.times do |i|
      if hold[i] == 0 then
        @computer.cards[i] = @idx[i+15]
      end
    end

    setAction()
    puts "<player's cards>"
    @player.display

    puts "\n-Enter \"0\" to result-"
    print "(player) "
    keyWait('0')

  end

  def result

    @player.cardSort
    @computer.cardSort

    setAction()
    puts "<player's cards>"
    @player.display
    @player.judgeHand
    print "\n"

    puts "<computer's cards>"
    @computer.display
    @computer.judgeHand
    print "\n"

    if @player.hand > @computer.hand || (@player.hand == @computer.hand && @player.max_card > @computer.max_card) then
      puts "You Win!!"
    elsif @player.hand < @computer.hand || (@player.hand == @computer.hand && @player.max_card < @computer.max_card) then
      puts "You Lose..."
    else
      puts "Draw."
    end

    puts "\n-Enter \"1\" to continue."
    puts "-Enter \"0\" to exit."
    print "(player) "
  end

  def setAction
    puts "\n//action #{@action}//////////////////\n"
    @action = @action + 1
  end

  def keyWait(key)
    input = '1'
    until (key == input) do
      input = gets.chomp
    end
  end
end

main_input = '1'
while main_input == '1' do
  poker = Poker.new
  poker.init
  poker.shuffle
  poker.deal
  poker.swap
  poker.result
  main_input = gets.chomp
end
