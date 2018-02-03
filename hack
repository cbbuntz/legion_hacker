#!/usr/bin/ruby

require './string.rb'
require './color.rb'
require './matrix.rb'

termcap = `stty -a <"$(tty)"`

$lines = termcap.gsub(/.*?(rows)\s*(\d+).*/m, '\\2').to_i
$columns = termcap.gsub(/.*?(columns)\s*(\d+).*/m, '\\2').to_i
$center_line = $lines / 2
$center_column = $columns / 2

@alienlang = File.read('./text/chars').gsub(/\s/m, '').chars

@red = "\e[38;5;196;48;5;16m"
@redbg = "\e[38;5;231;48;5;196m"
@green = "\e[38;5;46m"
@greenbg = "\e[42m"
@alien = "\e[38;5;155;48;5;16m"
@normal = "\e[0m"
@blink = "\e[05m"
@blinkoff = "\e[25m"
@clear = "\e[2J"

def setpos(line, col)
    "\e[#{line};#{col}H"
end

def set_col(col)
    "\e[#{col}G"
end

def set_line(_col)
    "\e[#{line};0H"
end

def progress(title, tail = '', color = "\e[38;5;231;48;5;34m")
    puts
    on = "\e[1m" << color
    off = "\e[1;38;5;231;48;5;16m"
    n = 50
    str = title.center(n)
    print "\r[#{off}#{str}]\e[2G"
    print on
    str.chars.each do |c|
        print c
        sleep 0.04
    end
    puts "\n#{@normal}#{tail.center(n + 2)}\n\n"
end

def alien_language(n = 100)
    (0..n).each do |line|
        s = @alienlang.shuffle[0, $columns] * ''
        pos = rand($lines - 8)
        print "\e[#{pos};1H"
        bright = (($lines - pos) / $lines.to_f)
        gradient [160 + line, 0.3, bright], [320 - line, 1, 0], s

        posc = rand($columns)
        bright = (($columns - posc) / $columns.to_f)
        s = s[0, $lines - 4]
        gradient_col [180 + line, 0.3, bright], [320 - line, 1, 0.0], s, posc
        sleep 0.03
    end
end

def alien_gibberish(n)
    @alienlang.shuffle[0, n] * ''
end

@ascii_gibberish = ('!'..'~').to_a << (0..10).to_a * 8
def ascii_gibberish(n)
    Array.new(n) { |_i| @ascii_gibberish.sample } * ''
end

def type(s, line = nil, sec = 0.06, wait = 0.9)
    print "\e[#{line};0H" if line
    print "#{@green}\r> \e[K"
    print "\e]50;CursorShape=0\C-G"
    sleep wait
    s.chars.each { |c| print c; sleep sec }
    puts "\e[0m\e]50;CursorShape=1\C-G"
end

def clear_lines
    print "\e[2A\r\e[K\e[1A\e[K\e[1A\e[K\e[1A\e[K"
end

system('clear')
print "\e[38;5;46m"
#  banner =  `figlet -f big -t "LEGION  HACKER"` + "\n\n\n\n\n"
banner = `cat ./text/banner` + "\n\n\n\n\n"
#  cia_banner =  `figlet -f big -t "  C I A  "` + "\n\n\n\n\n"
cia_banner = `cat ./text/CIA` + "\n\n\n\n\n"

print banner

print "\e[10;0H"
progress 'LOADING', 'READY'

target = 'CIA'
type "HACK #{target.upcase}"
#
print "\e[2A\r\e[K\e[1A\e[K\e[1A\e[K\e[1A\e[K\e[1A"

#  print "\e[10;0H"
puts "💀💀💀💀💀\e[1;05m#{@red} WARNING \e[0m💀💀💀💀💀".at_line(9)
puts "\e[31m YOU ARE ABOUT TO HACK #{target}.#{@green}"
print "\e[K  Do you wish to continue?"

print "\e[14;0H"
sleep 1.2

clear_lines
progress 'Hacking ' + target, "\e[1;05m#{@red}#{' RESTRICTED ACCESS ONLY '.center(50, '*')}\e[0m"

#  sleep 5

type 'CRACK PASSWORD && OVERRIDE ALL SECURITY', 14, 0.08, 0.2
#  sleep 0.25

alien_language 20

stra = (1..$lines).map { |i| setpos(i, 0) << "\e[K\r" }
cia_banner.split(/\n/).each.with_index { |s, i| stra[i] << s }

address = (0..3).map { |_i| rand(255) } * '.'

stra[10] << @green.to_s << 'ACCESS GRANTED'.center(50)
stra[11] << @normal.to_s <<
    "Connected to #{target} at #{address}".center(50) <<
    @green

print @green
stra.shuffle.each do |s|
    print s
    sleep 0.035
end

print "\e[14;0H"
type 'SCAN DATABASE && DOWNLOAD RECORDS'
clear_lines
progress 'Scanning database', '78651 records found.'

print "\e[4A"
#  clear_lines
progress 'Downloading records', 'Download complete.'

type 'ANALYZE DATA && ENHANCE'
clear_lines
progress 'Analyzing data', '237 Visual Basic GUIs found.'
#  sleep 0.25
print "\e[4A"
progress 'Enhancing', '3,359,974 Visual Basic GUIs found.'

#  sleep 0.25
type 'DECRYPT DATA'
clear_lines

decrypted = ' WE ARE THE ILLUMINATI '

print "\e[10;0H\r\e[s"
181.times do |i|
    s = matrix_gibberish(32) << ' ' * 8
    print "\e[u"
    gradient [6 * i, 0.5, 1.0], [10 * i, 1.0, 1.0], s
    len = (decrypted.length * (i / 180.0)).round
    print "\e[u\n\r\e[K"
    print decrypted[0..len] << s[0] << "\e[7m \e[27m\n\r\e[K"
    sleep 0.05
end

print "\e[11;0H\r#{@red}#{decrypted}   "
print "\e[14;0H"

type 'UPLOAD VIRUS'
clear_lines
progress '💀💀💀💀 Uploading virus 💀💀💀💀', 'Virus installation successful.', @redbg

type 'INITIALIZE SELF-DESTRUCT SEQUENCE'
clear_lines
progress '💀💀💀💀  INITIALIZING SELF-DESTRUCT  💀💀💀💀', 'Self-destruction in progress.', @redbg

matrix

print @clear
hashes = '#' * $columns
str = '       HACKING  COMPLETE     '
press_any_key = '  PRESS ANY KEY TO CONTINUE  '.center($columns, '#')
linestart = $center_line - 2

(0..255).each do |i|
    print "\e[#{linestart};0H"
    print "\e[38;2;0;#{i};0m" << hashes
    print "\e[#{linestart + 1};0H"
    print "#{hashes}\e"
    print "\e[#{linestart + 1};#{($columns - str.length) / 2 + 1}H#{@blink}#{str}#{@blinkoff}"
    print "\e[#{linestart + 2};0H" << press_any_key
    print "\e[#{linestart + 3};0H" << hashes
    print "\r"
    sleep 0.002
end
