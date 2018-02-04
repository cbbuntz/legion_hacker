
$LOAD_PATH << '.'
require 'string.rb'
include EscSequence

@buffer = DATA.read.split(/\n/)
def color_example
    screen :new
    code_color = rgb256_fg(3, 3, 3)
    result_color = rgb256_fg(3, 1, 0)
    test_string = '* TEST STRING *'
    @buffer.each do |line|
        break if line.match?(/ex2/)
        next unless line.match?(/^[^#]/)
        result = eval(line)
        print " #{code_color}#{line.chomp}"
        print "\n  #{result}\e[0m"
        puts "#{result_color}=>  #{result.to_s.dump}\e[0;21m".at_col(30)
    end
    sleep 5
    screen :restore
end

def cursor_example
    c = [[0x7799FF, 0x000000], [0xFFFFFF],
         [0x33EE88], [0x66FF22], [0xFFFF77]].map { |v| color :truecolor, *v }

    screen :new

    kill = EscSequence.kill
    puts "#{kill}Examples 2".center(30).bold.color(:rgb256, [5, 5, 5], [0, 1, 3])

    print "\n".style :reset
    cursor :store

    [
        ['line_col', 4, 3],
        ['line_col', 20, 12],
        ['line_col', 19, 11],
        ['line_col', 10, 10],
        ['v', 4],
        ['>', 3],
        ['^', 1],
        ['<', 2]

    ].each do |argv|
        print "  #{c[0]}#{kill}cursor#{c[1]}(#{c[2]}:#{argv * ', '}#{c[1]})".at_pos(2, 1)

        cursor :restore
        print c[4]
        4.times do
            cursor(*argv)
            print 'X'
            sleep 0.5
            delete_backward_char
        end
        cursor :store
    end
    screen :restore
end

def scroll_example
    screen :store
    screen :reset

    print @buffer.join("\n").style :reset

    line_nr = 0
    sleep 0.5
    10.times do
        line_nr += 1
        screen :scroll_down
        cursor :cr
        sleep 0.125
    end
    10.times do
        screen :scroll_up
        line_nr -= 1
        print @buffer[line_nr].at_line(0)
        cursor :cr
        sleep 0.125
    end

    sleep 1
    screen :restore
end

color_example
cursor_example
scroll_example

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
