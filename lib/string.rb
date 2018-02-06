
require_relative 'escape.rb'

class String
    private

    @@ansi_color_index = EscSequence::ANSI_COLOR.each_value.to_a

    @@style = EscSequence::STYLE

    public

    def ansi_color(*v)
        "\e[" <<
            v.map.with_index do |x, i|
                EscSequence.get_ansi_color(x, i)
            end.join(';') << 'm' <<
            self
    end

    def style(*v)
        styles = v.map { |i| @@style[i.to_sym] }.transpose
        "\e[" << styles[0].join(';') << 'm' <<
            self <<
            "\e[" << styles[1].join(';') << 'm'
    end

    def bold
        style(:bold)
    end

    def italic
        style(:italic)
    end

    def underline
        style(:underline)
    end

    def blink
        style(:blink)
    end

    def inverse
        style(:inverse)
    end

    def highlight
        style(:highlight)
    end

    def conceal
        style(:conceal)
    end

    def crossout
        style(:crossout)
    end

    def strikeout
        style(:crossout)
    end

    # all methods with 'set' prefix are in-place
    def set_style(*v)
        styles = v.map { |i| @@style[i.to_sym] }.transpose
        prepend("\e[" << styles[0].join(';') << 'm')
        concat("\e[" << styles[1].join(';') << 'm')
    end

    def set_bold
        set_style(:bold)
    end

    def set_italic
        set_style(:italic)
    end

    def set_underline
        set_style(:underline)
    end

    def set_blink
        set_style(:blink)
    end

    def set_inverse
        set_style(:inverse)
    end

    def set_highlight
        set_style(:highlight)
    end

    def set_conceal
        set_style(:conceal)
    end

    def set_crossout
        set_style(:crossout)
    end

    def set_strikeout
        set_style(:crossout)
    end

    def at_col(c)
        "\e[#{c}G"      << self
    end

    def at_pos(l, c)
        "\e[#{l};#{c}H" << self
    end

    def at_line(l)
        "\e[#{l};0H"    << self
    end

    def set_col(_c)
        prepend("\e[#(c)}H")
    end

    def set_pos(l, c)
        prepend("\e[#{l};#{c}H")
    end

    def set_line(l)
        prepend("\e[#{l};0H")
    end

    def save_pos_pre
        "\e[s" << self
    end

    def save_pos_post
        self << "\e[s"
    end

    def restore_pos
        "\e[s" << self
    end

    def color(type, *v)
        EscSequence.color(type, *v) << self
    end
    alias colour color

    def set_color(type, *v)
        prepend(EscSequence.send(color, type, *v))
    end
    alias set_colour set_color
end
