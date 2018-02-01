module VimPos
    @vim_pos_format = {
        k: "\e[%uA",
        j: "\e[%uB",
        l: "\e[%uC",
        h: "\e[%uD",
        line_col: "\e[%u;%uH",
        G: "\e[%uH",
        r: "%c",
        R: "%s",
        gg: "\e[0;0H",
        '|': "\e[%uG",
        m: "\e[s",
        "'": "\e[u",
        "^": "\r",
        "0": "\r",
        "<CR>": "\n\r",
        "`": "\e[u",
        x: " \b",
        X: "\b "
    }

    def VimPos.vim_pos s
        s.scan(/(\d*)([^R])|(R)([^\e]*)(\e)/).map{|i| i.compact}.reject{|x| x.length == 0}.map{|i|
            i
        }
        #  s.scan(/\d*\D/).reject{|x| x.length == 0}.map{|i|
        #  count,cmd = i.partition(/\D/)
        #  @vim_pos_format[cmd.to_sym] % count
        #  }.join
    end
end

