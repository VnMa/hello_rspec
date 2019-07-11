class Bowling
        attr_reader :score

        def initialize
                @score = 0
        end

        def hit(count)
                @score += count
        end
end