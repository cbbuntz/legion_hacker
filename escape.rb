$LOAD_PATH << '.'
require 'util.rb'

module EscSequence
    @ansi_color = {
        black:   [30, 40],
        red:     [31, 41],
        green:   [32, 42],
        yellow:  [33, 43],
        blue:    [34, 44],
        magenta: [35, 45],
        cyan:    [36, 46],
        white:   [37, 47],
    }

    ANSI_COLOR = @ansi_color
    
    @ansi_color_index = @ansi_color.each_value.to_a

    def EscSequence.get_ansi_color *v
        #  Numeric for compatibility with ruby < 2.4
        if v[0].is_a? Numeric
            ret = @ansi_color_index[v[0].to_i]
        elsif v[0].is_a? Symbol
            ret =@ansi_color[v[0]]
        elsif v[0].is_a? String
            ret = @ansi_color[v[0].to_sym]
        end
        if v[1]
            return ret[v[1]]
        else
            return  ret
        end
    end
    
    @style = {
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
    }
    
    STYLE = @style

    @ansi = @style.merge(@ansi_color)
    ANSI = @ansi

    def EscSequence.style *v
        styles = v.map{|i| @EscSequence::STYLE[i.to_sym]}.transpose
        [
            "\e[" << styles[0].join(';') << "m",
            "\e[" << styles[1].join(';') << "m"
        ]
    end

    @color_format = {
        ansi: "\e[%um",

        truecolor: ["\e[38;2;%u;%u;%um", "\e[48;2;%u;%u;%um"],
        truecolor_fg: "\e[38;2;%u;%u;%um",
        truecolor_bg: "\e[48;2;%u;%u;%um",

        rgb256: ["\e[38;5;%um", "\e[48;5;%um"],
        rgb256_fg: "\e[38;5;%um",
        rgb256_bg: "\e[48;5;%um",
        
        grayscale: ["\e[38;5;%um", "\e[48;5;%um"],
        greyscale: ["\e[38;5;%um", "\e[48;5;%um"]
    }
    
    def EscSequence.process_rgb256 *v
        if v.nil?
        elsif v[0].is_a? Array
            [
                EscSequence.process_rgb256(*v[0]) ,
                EscSequence.process_rgb256(*v[1])
            ]
        else
            16 + (v[0] * 36) + (v[1] * 6) + v[2]
        end
    end

    #  Matching method names so that format can send method
    #  rgb256 expects arguments (int, int int), where each 0 <= v <= 5
    def EscSequence.rgb256 *v
        (@color_format[:rgb256][0,v.length]*'') % EscSequence.process_rgb256(*v)
    end

    def EscSequence.rgb256_fg *v
        @color_format[:rgb256_fg] % EscSequence.process_rgb256(*v)
    end

    def EscSequence.rgb256_bg *v
        @color_format[:rgb256_bg] % EscSequence.process_rgb256(*v)
    end
    
    # 0 <= v < 24
    def EscSequence.grayscale *v
        v.map{ |i| (i.to_i % 24) + 232 }.map.with_index{ |c,i|
            @color_format[:rgb256][i] % c
        }*''
    end
    def EscSequence.grayscale_fg v
        @color_format[:rgb256_fg] % ((v.to_i % 24) + 232)
    end
    def EscSequence.grayscale_bg v
        @color_format[:rgb256_bg] % ((v.to_i % 24) + 232)
    end
    
    def EscSequence.hex_to_rgb(v)
        b = (v & 0x0000ff)
        g = (v & 0x00ff00) >> 8
        r = (v & 0xff0000) >> 16
        [r, g, b]
    end

    def EscSequence.process_truecolor *v
        if v[0].is_a? Array
            v.map {|x| x.map(&:to_i) }
                 
        elsif (v.are_a? Numeric)

            if v.length == 3
                v.map(&:to_i)
            elsif v.length == 2
                v.map{|i|  EscSequence.hex_to_rgb(i.to_i) }
            elsif v.length == 1
                EscSequence.hex_to_rgb(v[0].to_i)
            end

        else
            raise 'invalid arguments to truecolor'
        end
    end

    def EscSequence.truecolor *v
        (@color_format[:truecolor][0,v.length]*'') % 
            EscSequence.process_truecolor(*v).flatten
    end

    def EscSequence.truecolor_fg *v
        @color_format[:truecolor_fg] % EscSequence.process_truecolor(*v)
    end

    def EscSequence.truecolor_bg *v
        @color_format[:truecolor_bg] % EscSequence.process_truecolor(*v)
    end

    def EscSequence.ansi *v
        "\e[%sm" %
            (v.map.with_index{|c,i| EscSequence.get_ansi_color(c)[i] } * ';')
    end   
    
    def EscSequence.ansi_fg v
        "\e[#{EscSequence.get_ansi_color(v)[0]}m"
    end   
    
    def EscSequence.ansi_bg v
        "\e[#{EscSequence.get_ansi_color(v)[1]}m"
    end   
    
    def EscSequence.color type, *v
        v = EscSequence.send(type, *v)
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
        SCROLL_N_DN:   "\e[%uS",
    }
    def EscSequence.screen cmd, *v
        if cmd =~ /scroll_n/i
            EscSequence::SCREEN[cmd.to_sym] % v[0]
        else
            EscSequence::SCREEN[cmd.to_sym]
        end
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
        CR:       "\r",
    }

    def EscSequence.cursor cmd, *v
        @cursor_format[cmd.to_sym] % v.map(&:to_i)
    end
    #  How to alias in module namespace?
    def EscSequence.pos cmd, *v
        @cursor_format[cmd.to_sym] % v.map(&:to_i)
    end
    
    def EscSequence.cursor_pos *v
        @cursor_format[:line_col] % v.map(&:to_i)
    end
    
    def EscSequence.up(v = 1)    @cursor_format[:up]    % v.to_i end
    def EscSequence.down(v = 1)  @cursor_format[:down]  % v.to_i end
    def EscSequence.right(v = 1) @cursor_format[:right] % v.to_i end
    def EscSequence.left(v = 1)  @cursor_format[:left]  % v.to_i end
    
    def EscSequence.save_pos()    @cursor_format[:store] end
    def EscSequence.store_pos()   @cursor_format[:store] end
    def EscSequence.restore_pos() @cursor_format[:restore] end
    
    def EscSequence.kill
        "\e[K"
    end   
    def EscSequence.kill_line
        "\r\e[K"
    end   
    def EscSequence.kill_lines a, b
        a,b = [a,b].sort
        (a..b).map{|line| "\e[#{line}H\r\e[K" }.join
    end   
    def EscSequence.delete_backward_char
        "\b \b"
    end   
    def EscSequence.delete_forward_char
        " "
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
    }

    def EscSequence.cursor_shape v
        "\e]50;CursorShape=#{EscSequence::CURSOR_SHAPE[v.to_s.to_sym]}\C-G"
    end
    
end

