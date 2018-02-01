require './string.rb'

def examples1
    print EscSequence.screen :new
    code_color = EscSequence.rgb256_fg(3,3,3)
    result_color = EscSequence.rgb256_fg(3,1,0)
    test_string = '* TEST STRING *'
    DATA.each_line do |line|
        break if line =~ /ex2/
        if line =~ /^[^#]/
            result = eval(line)
            print " #{code_color}#{line.chomp}"
            print "\n  #{result}\e[0m"
            puts "#{result_color}=>  #{result.to_s.dump}\e[0;21m".at_col(30)
        end
    end
    sleep 5
    print EscSequence.screen :restore
end

def examples2
    c = [ [0x7799FF,0x000000], [0xFFFFFF],
          [0x33EE88], [0x66FF22], [0xFFFF77]
    ].map{|v| EscSequence.color(:truecolor, *v) }

    print EscSequence.screen :new

    kill = EscSequence.kill
    puts "#{kill}Examples 2".center(30).bold.color(:rgb256,[5,5,5],[0,1,3])

    print "\n".style :reset
    EscSequence.cursor(:store)

    [
        ['line_col',4,3],
        ['line_col',20,12],
        ['line_col',19,11],
        ['line_col',10,10],
        ['v',4],
        ['>',3],
        ['^',1],
        ['<',2],

    ].each do |argv|
        print "  #{c[0]}#{kill}EscSequence#{c[1]}.pos(#{c[2]}#{argv*', '}#{c[1]}) << #{c[3]}\"X\"".at_pos(2,1)
        
        print EscSequence.cursor :restore
        print c[4]
        4.times {
            print EscSequence.pos(*argv) << "X"
            sleep 0.5
            print EscSequence.delete_backward_char
        }
        print EscSequence.cursor :store
    end
    print EscSequence.screen :restore
    sleep 2
end

examples1
examples2

__END__
"This is rgb256".color(:rgb256, [5,5,5], [0,1,3])
"This is rgb256_fg".color(:rgb256_fg, 0,1,3)
"Truecolor is nice".color(:truecolor,0xFF00FF)
"using hex integers".color(:truecolor,0x77FF00, 0xFF0077)
"using decimal ints".color(:truecolor_bg,127,64,200)
"arguments are forgiving".color(:truecolor, [27,64,200])
"but depend on the format".color(:truecolor_bg, 27,64,200)
"two arrays".color(:truecolor, [127,64,200], [44,111,44])
"add style inline".color(:truecolor_bg,0x007700).bold
"HELLO".bold.color(:truecolor, 0xFF1100, 0x22AACC)
test_string.bold
test_string
test_string.set_color(:truecolor, 0xFF1100, 0x22AACC)
test_string
test_string.at_col(30)
