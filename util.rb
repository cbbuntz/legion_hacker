class Array
    def homogeneous?
        self.inject {|y,v| y && v.is_a?(self[0].class) }
    end
    
    def are_a? c
        self.inject {|y,v| y && v.is_a?(c) }
    end
end

