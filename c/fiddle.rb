require 'fiddle'
require 'fiddle/import'
include Fiddle::CParser
$LOAD_PATH << '.'
libm = Fiddle.dlopen('libcolorspace.so')

float = Fiddle::TYPE_FLOAT
int = Fiddle::TYPE_INT
long = Fiddle::TYPE_LONG
void = Fiddle::TYPE_VOID
voidp = Fiddle::TYPE_VOIDP

func = Fiddle::Function.new(
    libm['hsv_to_rgb'],
  [float, float, float, long, voidp],
  long
)

print_hsv = Fiddle::Function.new(
    libm['print_hsv'],
  [float, float, float, long, voidp],
  void
)

print_gradient = Fiddle::Function.new(
    libm['print_gradient'],
  [float, float, float, float, float, float, voidp],
  void
)

#  print "\e[1m"
str = "                     ".center(100)
720.times{|i|
    print "\e[H"
    (0..50).each {|v|
            print_gradient.(v*i, 1, v*0.02, (i-v*i)*2, 1, v*0.02, str)
    }
sleep 0.02
}
