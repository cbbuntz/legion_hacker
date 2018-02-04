
class Array
    def homogeneous?
        inject { |y, v| y && v.is_a?(self[0].class) }
    end

    def are_a?(c)
        inject { |y, v| y && v.is_a?(c) }
    end
end
