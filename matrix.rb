class Crawler
    attr_accessor :line, :line2, :visible
    @@hsv1 = [120, 1, 0.5]
    @@hsv2 = [120, 0.5, 1]
    @@hsv3 = [120, 0.95, 0.2]
    @@color1 = "\e[21m" << format_color_hsv(120, 1, 0.8, 0) + format_color_hsv(120, 1, 0.125, 1)
    @@color2 = "\e[1m" <<
               format_color_hsv(123, 0.5, 1, 0) <<
               format_color_hsv(122, 0.85, 0.35, 1)
    @@color3 = "\e[38;5;22;48;20m"
    @@black = "\e[0;38;5;16m"

    def initialize(s, col, line = 0)
        @s = s
        @chars = s.chars
        @col = col
        @len = s.length
        @line = line
        @line2 = @line - ($lines / 2)
        @color1 = @@black
        @color2 = @@black
        @color3 = @@black
        @fade = "\e[0m"
        @visible = false
    end

    def print_pos(char, os)
        print "\e[#{[@line + os, 0].max};#{@col}H#{char}"
    end

    def check_visible
        if @line == 1
            @color1 = @@color1
            @color2 = @@color2
            @visible = true
        end
    end

    def print_crawler2
        if !@visible
            @line = (@line + 1) % $lines
            @line2 = (@line2 + 1) % $lines
            check_visible
        else
            @line = (@line + 1) % $lines
            print "\e[#{@line};#{@col}H#{@color2}#{@s[@line]}"
            print "\e[A#{@color1}\b#{@s[@line]}"

            print "\e[#{@line2};#{@col}H#{@fade} "
            @color3 = (@line2 = (@line2 + 1) % $lines) == 0 ? @@color3 : @color3
            print "\e[#{@line2};#{@col}H#{@color3}#{@s[@line2]}"
        end
    end

    def check_visible_end
        if @line <= 1
            @color1 = @@black
            @color2 = @@black
            @visible = false
        end
    end

    def print_crawler2_end
        if @visible
            check_visible_end
            @line = (@line + 1) % $lines
            print "\e[#{@line};#{@col}H#{@color2}#{@s[@line]}"
            print "\e[A#{@color1}\b#{@s[@line]}"
        end

        print "\e[#{@line2};#{@col}H\e[0m "
        @line2 = (@line2 + 1) % $lines
        if @line2 <= 0
            @color3 = @@black
            print "\e[#{@line2};#{@col}H#{@color3}"
        else
            print "\e[#{@line2};#{@col}H#{@color3}#{@s[@line2]}"
        end
    end
end

@matrix_gibberish = File.read('./text/matrix_gibberish').chars

def matrix_gibberish(n)
    Array.new(n) { |_i| @matrix_gibberish.sample } * ''
end

def matrix
    crawlers = Array.new($columns) { |i| Crawler.new(ascii_gibberish($lines), i, -rand($lines)) }
    center = ($columns / 2).round
    crawlers[center].print_crawler2 until crawlers[center].visible
    20.times do
        crawlers[center].print_crawler2
        sleep 0.09
    end
    ($lines + 1).times do
        crawlers.each(&:print_crawler2)
        sleep 0.08
    end
    ($lines + $lines / 2).times do
        crawlers.each(&:print_crawler2_end)
        sleep 0.08
    end
end
