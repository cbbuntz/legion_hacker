require './escape.rb'

class String
    private
    @@ansi_color_index = EscSequence::ANSI_COLOR.each_value.to_a

    @@style = EscSequence::STYLE

    public
    
    def ansi_color *v
        "\e[" <<
        v.map.with_index {|x, i|
            EscSequence.get_ansi_color(x, i)
        }.join(';') << "m" <<
        self
    end

    def style *v
        styles = v.map{|i| @@style[i.to_sym]}.transpose
        "\e[" << styles[0].join(';') << "m" << 
        self <<
        "\e[" << styles[1].join(';') << "m"
    end

    def bold()      self.style(:bold)      end
    def italic()    self.style(:italic)    end
    def underline() self.style(:underline) end
    def blink()     self.style(:blink)     end
    def inverse()   self.style(:inverse)   end
    def highlight() self.style(:highlight) end
    def conceal()   self.style(:conceal)   end
    def crossout()  self.style(:crossout)  end
    def strikeout() self.style(:crossout)  end

    # all methods with 'set' prefix are in-place
    def set_style *v
        styles = v.map{|i| @@style[i.to_sym]}.transpose
        self.prepend("\e[" << styles[0].join(';') << "m")
        self.concat("\e[" << styles[1].join(';') << "m")
    end
    
    def set_bold()      self.set_style(:bold)      end
    def set_italic()    self.set_style(:italic)    end
    def set_underline() self.set_style(:underline) end
    def set_blink()     self.set_style(:blink)     end
    def set_inverse()   self.set_style(:inverse)   end
    def set_highlight() self.set_style(:highlight) end
    def set_conceal()   self.set_style(:conceal)   end
    def set_crossout()  self.set_style(:crossout)  end
    def set_strikeout() self.set_style(:crossout)  end

    def at_col(c)     "\e[#{c}G"      << self end
    def at_pos(l, c)  "\e[#{l};#{c}H" << self end
    def at_line(l)    "\e[#{l};0H"    << self end

    def set_col(c)    self.prepend("\e[#(c)}H")     end
    def set_pos(l, c) self.prepend("\e[#{l};#{c}H") end
    def set_line(l)   self.prepend("\e[#{l};0H")    end

    def save_pos_pre()  "\e[s" << self end
    def save_pos_post() self << "\e[s" end
    def restore_pos()   "\e[s" << self end
    
    def color type, *v
        EscSequence.send(type, *v) << self
    end

    def set_color type, *v
        self.prepend(EscSequence.send(type, *v))
    end
end

