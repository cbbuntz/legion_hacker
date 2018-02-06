require 'figlet'
require_relative 'escape.rb'
require_relative 'util.rb'

include EscSequence

font = Figlet::Font.new('data/fonts/big.flf')
figlet = Figlet::Typesetter.new(font)

class String
    def nonblank_length
        v_start = self =~ /(?<=\s)\S/
        v_end = self =~ /\s*$/
        v_end - v_start
    rescue StandardError
        0
    end

    def last_nonblank
        self =~ /\s*$/
    end
end
