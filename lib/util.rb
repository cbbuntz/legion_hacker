# Methods to ensure all types are the same
class Array
    def homogeneous?
        #  inject { |y, v| y && v.is_a?(self[0].class) }
        map { |v| v.is_a?(self[0].class) }.inject(:&)
    end

    def are_a?(c)
        #  inject { |y, v| y && v.is_a?(c) }
        map { |v| v.is_a?(c) }.inject(:&)
    end
end

if RUBY_VERSION >= '2.2.0'
    #  Add some handy methods
    class Integer
        def digits(base = 10)
            to_s(base).chars.map { |v| v.to_i(base) }
        end

        def each_digit(base = 10, &block)
            digits(base).each(&block)
        end
    end
else
    # Not using Numeric since Float would require different methods
    class Integer
        def digits(base = 10)
            to_s(base).chars.map { |v| v.to_i(base) }
        end

        def each_digit(base = 10, &block)
            digits(base).each(&block)
        end
    end
end
