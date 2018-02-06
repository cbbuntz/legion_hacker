$LOAD_PATH << '.'
require_relative 'util'

module EscSequence
    ANSI_COLOR = {
        black:   [30, 40],
        red:     [31, 41],
        green:   [32, 42],
        yellow:  [33, 43],
        blue:    [34, 44],
        magenta: [35, 45],
        cyan:    [36, 46],
        white:   [37, 47]
    }.freeze

    @ansi_color_index = EscSequence::ANSI_COLOR.each_value.to_a

    def self.get_ansi_color(*v)
        #  Numeric for compatibility with ruby < 2.4
        if v[0].is_a? Numeric
            ret = @ansi_color_index[v[0].to_i]
        elsif v[0].is_a? Symbol
            ret = EscSequence::ANSI_COLOR[v[0]]
        elsif v[0].is_a? String
            ret = EscSequence::ANSI_COLOR[v[0].to_sym]
        end
        if v[1]
            return ret[v[1]]
        else
            return ret
        end
    end

    EscSequence::STYLE = {
        reset:     [0, 0],
        bold:      [1, 21],
        italic:    [3, 23],
        italics:   [3, 23],
        underline: [4, 24],
        blink:     [5, 25],
        reverse:   [7, 27],
        inverse:   [7, 27],
        highlight: [7, 27],
        conceal:   [8, 28],
        hide:      [8, 28],
        invisible: [8, 28],
        crossout:  [9, 29],
        strikeout: [9, 29]
    }.freeze

    ANSI = EscSequence::STYLE.merge(EscSequence::ANSI_COLOR)

    def self.style(*v)
        styles = v.map { |i| EscSequence::STYLE[i.to_sym] }.transpose
        [
            "\e[" << styles[0].join(';') << 'm',
            "\e[" << styles[1].join(';') << 'm'
        ]
    end

    #  better name for these methods? :set_style should be reserved for class
    def style_on(*v)
        styles = v.map { |i| EscSequence::STYLE[i.to_sym] }.transpose
        "\e[" << styles[0].join(';') << 'm'
    end

    def style_off(*v)
        styles = v.map { |i| EscSequence::STYLE[i.to_sym] }.transpose
        "\e[" << styles[1].join(';') << 'm'
    end

    @color_format = {
        ansi: "\e[%um",

        truecolor: ["\e[38;2;%u;%u;%um", "\e[48;2;%u;%u;%um"],
        truecolor_fg: "\e[38;2;%u;%u;%um",
        truecolor_bg: "\e[48;2;%u;%u;%um",

        truecolour: ["\e[38;2;%u;%u;%um", "\e[48;2;%u;%u;%um"],
        truecolour_fg: "\e[38;2;%u;%u;%um",
        truecolour_bg: "\e[48;2;%u;%u;%um",

        rgb256: ["\e[38;5;%um", "\e[48;5;%um"],
        rgb256_fg: "\e[38;5;%um",
        rgb256_bg: "\e[48;5;%um",

        grayscale: ["\e[38;5;%um", "\e[48;5;%um"],
        greyscale: ["\e[38;5;%um", "\e[48;5;%um"]
    }

    #  Accepts string
    def self.process_rgb256(*v)
        if v.nil?
            ''
        elsif v[0].is_a? Array
            if v.length == 2
                [EscSequence.process_rgb256(*v[0]), EscSequence.process_rgb256(*v[1])]
            else
                EscSequence.process_rgb256(*v[0])
            end
        elsif v.are_a? String
            v.map { |i| EscSequence.process_rgb256(i.chars.map(&:to_i)) }
        elsif v.are_a? Numeric
            if v[0] > 5
                if v.length == 2
                    [EscSequence.process_rgb256(v[0].digits), EscSequence.process_rgb256(v[0].digits)]
                else
                    EscSequence.process_rgb256(v[0].digits)
                end
            else
                16 + (v[0] * 36) + (v[1] * 6) + v[2]
            end
        else
            raise 'Argument error to EscSequence.process_rgb256'
        end
    end

    #  Matching method names so that format can send method
    #  rgb256 expects arguments (int, int int), where each 0 <= v <= 5
    def self.rgb256(*v)
        (@color_format[:rgb256][0, v.length] * '') % EscSequence.process_rgb256(*v)
    end

    def self.rgb256_fg(*v)
        @color_format[:rgb256_fg] % EscSequence.process_rgb256(*v)
    end

    def self.rgb256_bg(*v)
        @color_format[:rgb256_bg] % EscSequence.process_rgb256(*v)
    end

    # 0 <= v < 24
    def self.grayscale(*v)
        v.map { |i| (i.to_i % 24) + 232 }.map.with_index do |c, i|
            @color_format[:rgb256][i] % c
        end * ''
    end

    def self.grayscale_fg(v)
        @color_format[:rgb256_fg] % ((v.to_i % 24) + 232)
    end

    def self.grayscale_bg(v)
        @color_format[:rgb256_bg] % ((v.to_i % 24) + 232)
    end

    def self.hex_to_rgb(v)
        b = (v & 0x0000ff)
        g = (v & 0x00ff00) >> 8
        r = (v & 0xff0000) >> 16
        [r, g, b]
    end

    def hex_to_rgb(v)
        EscSequence.hex_to_rgb v
    end

    def self.process_truecolor(*v)
        if v[0].is_a? Array
            v.map { |x| x.map(&:to_i) }

        elsif v.are_a? String
            v.map { |x| EscSequence.process_truecolor x.to_i(16) }
        elsif v.are_a? Numeric

            if v.length == 3
                v.map(&:to_i)
            elsif v.length == 2
                v.map { |i| EscSequence.hex_to_rgb(i.to_i) }
            elsif v.length == 1
                EscSequence.hex_to_rgb(v[0].to_i)
            end

        else
            raise 'invalid arguments to truecolor'
        end
    end

    def self.truecolor(*v)
        (@color_format[:truecolor][0, v.length] * '') %
            EscSequence.process_truecolor(*v).flatten
    end

    def self.truecolor_fg(*v)
        @color_format[:truecolor_fg] % EscSequence.process_truecolor(*v)
    end
    
    def self.truecolor_bg(*v)
        @color_format[:truecolor_bg] % EscSequence.process_truecolor(*v)
    end

    def self.ansi(*v)
        format("\e[%sm", (v.map.with_index { |c, i| EscSequence.get_ansi_color(c)[i] } * ';'))
    end

    def self.ansi_fg(v)
        "\e[#{EscSequence.get_ansi_color(v)[0]}m"
    end

    def self.ansi_bg(v)
        "\e[#{EscSequence.get_ansi_color(v)[1]}m"
    end

    def self.color(type, *v)
        EscSequence.send(type, *v)
    end

    def truecolor(*v)
        EscSequence.truecolor(v)
    end

    def truecolor_fg(*v)
        EscSequence.truecolor_fg(v)
    end

    def truecolor_bg(*v)
        EscSequence.truecolor_bg(v)
    end

    def ansi_color(*v)
        EscSequence.ansi(v)
    end

    def ansi_color_fg(*v)
        EscSequence.ansi_fg(v)
    end

    def ansi_color_bg(*v)
        EscSequence.ansi_bg(v)
    end

    def rgb256(*v)
        EscSequence.rgb256(*v)
    end

    def rgb256_fg(*v)
        EscSequence.rgb256_fg(*v)
    end

    def rgb256_bg(*v)
        EscSequence.rgb256_bg(*v)
    end

    def grayscale(*v)
        EscSequence.grayscale(v)
    end

    def grayscale_fg(*v)
        EscSequence.grayscale_fg(v)
    end

    def grayscale_bg(*v)
        EscSequence.grayscale_bg(v)
    end

    #  truecolour alias not working?
    alias truecolour     truecolor
    alias truecolour_fg  truecolor_fg
    alias truecolour_bg  truecolor_bg
    alias ansi_colour    ansi_color
    alias ansi_colour_fg ansi_color_fg
    alias ansi_colour_bg ansi_color_bg
    alias greyscale      grayscale
    alias greyscale_fg   grayscale_fg
    alias greyscale_bg   grayscale_bg

    def color(type, *v)
        EscSequence.color(type, *v)
    end

    def console_color(type, *v)
        print EscSequence.color(type, *v)
    end

    def console_style_reset(_type, *_v)
        print "\e[0m"
    end

    SCREEN = {
        store:         "\e[?1049h",
        new:           "\e[?1049h\e[2J\e[H",
        restore:       "\e[?1049l",
        clear:         "\e[2J",
        clear!:        "\e[2J\e[H",
        reset:         "\e[2J\e[H",
        scroll_up:     "\e[T",
        scroll_down:   "\e[S",
        scroll_dn:     "\e[S",
        scroll_n_up:  "\e[%uT",
        scroll_n_down: "\e[%uS",
        scroll_n_dn:   "\e[%uS",
        STORE:         "\e[?u049h",
        NEW:           "\e[?1049h\e[2J\e[H",
        RESTORE:       "\e[?1049l",
        CLEAR:         "\e[2J",
        CLEAR!:        "\e[2J\e[H",
        RESET:         "\e[2J\e[H",
        SCROLL_UP:     "\e[T",
        SCROLL_DOWN:   "\e[S",
        SCROLL_DN:     "\e[S",
        SCROLL_N_UP:  "\e[%uT",
        SCROLL_N_DOWN: "\e[%uS",
        SCROLL_N_DN:   "\e[%uS"
    }.freeze
    def self.screen(cmd, *v)
        if cmd.match?(/scroll_n/i)
            EscSequence::SCREEN[cmd.to_sym] % v[0]
        else
            EscSequence::SCREEN[cmd.to_sym]
        end
    end

    def screen(cmd, *v)
        print EscSequence.screen(cmd, *v)
    end

    @cursor_format = {
        pos:      "\e[%u;%uH",
        line_col: "\e[%u;%uH",
        line:     "\e[%uH",
        col:      "\e[%uG",
        up:       "\e[%uA",
        '^':      "\e[%uA",
        down:     "\e[%uB",
        'v':      "\e[%uB",
        right:    "\e[%uC",
        '>':      "\e[%uC",
        left:     "\e[%uD",
        '<':      "\e[%uD",
        store:    "\e[s",
        save:     "\e[s",
        restore:  "\e[u",
        home:     "\e[H",
        cr:       "\r",
        CR:       "\r"
    }

    def self.cursor(cmd, *v)
        @cursor_format[cmd.to_sym] % v.map(&:to_i)
    end

    def self.pos(cmd, *v)
        @cursor_format[cmd.to_sym] % v.map(&:to_i)
    end

    def self.line(*v)
        @cursor_format[:line] % v.map(&:to_i)
    end

    def self.cursor_pos(*v)
        @cursor_format[:line_col] % v.map(&:to_i)
    end

    def cursor(*v)
        print EscSequence.cursor(*v)
    end

    def cursor_pos(*v)
        print EscSequence.cursor_pos(*v)
    end

    def self.up(v = 1)
        @cursor_format[:up]    % v.to_i
    end

    def self.down(v = 1)
        @cursor_format[:down]  % v.to_i
    end

    def self.right(v = 1)
        @cursor_format[:right] % v.to_i
    end

    def self.left(v = 1)
        @cursor_format[:left]  % v.to_i
    end

    def self.save_pos
        @cursor_format[:store]
    end

    def self.store_pos
        @cursor_format[:store]
    end

    def self.restore_pos
        @cursor_format[:restore]
    end

    def self.kill
        "\e[K"
    end

    def console_kill
        print "\e[K"
    end

    def console_kill_line
        print "\r\e[K"
    end

    def console_kill_lines(a, b)
        a, b = [a, b].sort
        print (a..b).map { |line| "\e[#{line}H\r\e[K" }.join
    end

    def delete_backward_char
        print "\b \b"
    end

    def delete_forward_char
        print ' '
    end

    CURSOR_SHAPE = {
        block:      0,
        ibeam:      1,
        underscore: 2,
        BLOCK:      0,
        IBEAM:      1,
        UNDERSCORE: 2,
        '0':        0,
        '1':        1,
        '2':        2
    }.freeze

    def self.cursor_shape(v)
        "\e]50;CursorShape=#{EscSequence::CURSOR_SHAPE[v.to_s.to_sym]}\C-G"
    end

    def set_cursor_shape(v)
        print EscSequence.cursor_shape(v)
    end
   
    # replace all text to end of line
    def print_kill(*v)
        print "\e[K"
        print v
    end
end
