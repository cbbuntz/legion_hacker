#!/bin/ruby

include Math

RGB = Struct.new(:r, :g, :b) do
    attr_accessor :v

    def initialize(*v)
        if v.length == 3
            self.r, self.g, self.b = v.map(&:to_i)
            @v = ((r % 256) << 16) + ((g % 256) << 8) + (b % 256)
        elsif v.length == 1
            @v = v[0]
            hex_to_rgb(v[0])
        elsif v.length.zero?
            self.r, self.g, self.b, @v = [0] * 4
        else
            raise "RGB initialization takes 0, 1, or 3 argumnets. \
              You gave #{v.length}"
        end
    end

    def hex_to_rgb(v)
        self.b = (v & 0x0000ff)
        self.g = (v & 0x00ff00) >> 8
        self.r = (v & 0xff0000) >> 16
        [r, g, b]
    end

    def rgb_to_hex(r, g, b)
        @v = ((r % 256) << 16) + ((g % 256) << 8) + (b % 256)
    end

    def to_hex
        ((r % 256) << 16) + ((g % 256) << 8) + (b % 256)
    end

    def v=(v)
        RGB.new(v)
    end

    def to_a
        [r, g, b]
    end

    def colorcode
        to_a.map { |i| ((i % 256)) } * ';'
    end

    def print(*v)
        if v[0]
            layer = [38, 48][v[0]]
            "\e[#{layer};2;" + colorcode + 'm'
        else
            print(0)
        end
    end

    def inspect
        format('%06X', to_hex)
    end
end

#  TODO: test these methods and put them
#  somewhere appropriate if working
def print_rgb(fg, bg)
    fg && (print RGB.new(fg).print(0))
    bg && (print RGB.new(bg).print(1))
end

def hsv2rgb(h, s, v)
    i = (h / 120.0).floor
    frac = ((h / 120.0) - i)
    a = [1 - frac, frac, 0].rotate(-i)
    a = a.map { |x| [x * 2, 1].min }
    a = a.map { |x| v * ((1 - s) + x * s) }
    a.map { |x| (x * 255).round }
end

def hsl2rgb(h, s, l)
    c = (1 - (2 * l - 1).abs) * s
    hp = (h / 60.0)
    hmod = hp % 2
    x = c * (1 - (hmod - 1).abs)
    a = ([c, x].rotate(hmod.floor) + [0]).rotate(-((hp / 2)).floor)
    m = l - 0.5 * c
    a.map { |i| ((i + m) * 255).round }
end

def format_color(*v, fg_bg)
    "\e[#{[38, 48][fg_bg]};2;#{v * ';'}m"
end

def format_color_hsv(h, s, v, fg_bg = 0)
    "\e[#{[38, 48][fg_bg]};2;#{hsv2rgb(h, s, v).map(&:round) * ';'}m"
end

def printc(*v)
    print "\e[38;2;#{v * ';'}m"
end

def printc2(fg, bg)
    print "\e[38;2;#{fg * ';'}m\e[48;2;#{bg * ';'}m"
end

def blend(a, b, coef)
    c = a.map.with_index do |v, i|
        (v * (1.0 - coef) + coef * b[i])
    end
    hsv2rgb(*c).map(&:round)
end

def fade(msg, a, b, ms)
    steps = (60.0 * ms / 1000.0).round
    scale = 1.0 / steps
    (0..steps).each do |i|
        c = blend(a, b, i * scale)
        print "\e[u"
        printc(*c)
        print msg + "\r"
        sleep scale
    end
end

def gradient(a, b, s)
    scale = 1.0 / s.length

    s.chars.each.with_index do |v, i|
        c = blend(a, b, i * scale)
        printc(*c)
        print v
    end
end

def gradient_col(a, b, s, col)
    scale = 1.0 / s.length
    s.chars.each.with_index do |v, i|
        c = blend(a, b, i * scale)
        printc(*c)
        print print "\e[#{i};#{col}H#{v}"
    end
end
