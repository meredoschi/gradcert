# Important logical verifications
module Logic
  def self.within?(a, b, x)
    if x >= a && x <= b

      true

    else

      false

    end
  end

  # Assumes a, b are ranges which overlap
  def self.intersection_size(a, b)
    if b.first >= a.first

      if b.last <= a.last

        b.size

      else

        (b.first..a.last).size

      end

    else

      if b.last <= a.last

        (a.first..b.last).size

      else

        a.size

      end

    end
  end

  def self.intersect(a, b)
    @disjoint = 0

    if b.include?(a.first)
      @actual_start = a.first
    else
      @disjoint += 1
      @actual_start = b.first
      end

    if b.include?(a.last)
      @actual_finish = a.last
    else
      @disjoint += 1
      @actual_finish = b.last
      end

    if @disjoint == 2
      if a.first <= b.first && a.last >= b.last
        return p
      else
        return nil
      end
    else
      return (@actual_start..@actual_finish)
    end
   end
end
