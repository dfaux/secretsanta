class Person

  attr_accessor :name, :email, :relation, :santa

  def initialize(n, e, r)
    @name = n
    @email = e
    @relation = r
    @santa = nil
  end

  def to_s
    str = @name + " " + @email 
    if @relation 
      str += " [" + @relation + "]"
    end
    str
  end
end 
