# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/BlockNesting

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    c = 0
    while c < to_a.length
      yield(to_a[c])
      c += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    c = 0
    while c < to_a.length
      yield(to_a[c], c)
      c += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each { |item| result << item if yield(item) }
    result
  end

  def my_all?(pattern = nil)
    c = 0
    my_arr = []
    statement = true
    if block_given?
      to_a.length.times do
        statement = false unless yield(to_a[c])
        c += 1
      end
    elsif !pattern.nil?
      my_arr = if respond_to?(:to_ary)
                 self
               else
                 to_a
               end
      if pattern.is_a?(Numeric)
        statement = false unless my_arr.my_count(pattern) == size
      elsif pattern.is_a?(Regexp)
        length.times do
          statement = false unless my_arr[c].match(pattern)
          c += 1
        end
      elsif pattern.is_a?(String)
        if respond_to?(:to_s)
          statement = false unless my_arr.eql?(pattern)
        end
      elsif pattern.is_a?(Array)
        statement = false unless my_arr.my_count(pattern) == size
      elsif pattern.is_a?(TrueClass)
        statement = false unless my_arr.my_count(pattern) == size
      elsif pattern.is_a?(FalseClass)
        statement = false unless my_arr.my_count(pattern) == size
      else
        my_arr.length.times do
          if my_arr[c].is_a?(pattern)
            statement = true
          else
            statement = false
            break
          end
          c += 1
        end
      end
    elsif to_a.include? false
      statement = false
    end
    statement
  end

  def my_none?(pattern = nil)
    c = 0
    my_arr = []
    statement = false
    if block_given?
      to_a.length.times do
        statement = false if yield(to_a[c])
        c += 1
      end
    elsif !pattern.nil?
      my_arr = if respond_to?(:to_ary)
                 self
               else
                 to_a
               end
      if pattern.is_a?(Numeric)
        statement = true unless include? pattern
      elsif pattern.is_a?(Regexp)
        my_arr.length.times do
          statement = true unless my_arr[c].match(pattern)
          c += 1
        end
      elsif pattern.is_a?(String)
        if my_arr.respond_to?(:to_s)
          statement = true unless my_arr.eql?(pattern) || my_arr.include?(pattern)
        end
      elsif pattern.is_a?(Array)
        statement = true unless my_arr.include? pattern
      elsif pattern.is_a?(TrueClass)
        statement = true unless my_arr.include? pattern
      elsif pattern.is_a?(FalseClass)
        statement = true unless my_arr.include? pattern
      else
        my_arr.length.times do
          if !my_arr[c].is_a?(pattern)
            statement = true
          else
            statement = false
            break
          end
          c += 1
        end
      end
    elsif to_a.include? false
      statement = true
    end
    statement
  end

  def my_any?(pattern = nil)
    c = 0
    my_arr = []
    statement = true
    if block_given?
      to_a.length.times do
        statement = false unless yield(to_a[c])
        c += 1
      end
    elsif !pattern.nil?
      my_arr = if respond_to?(:to_ary)
                 self
               else
                 to_a
               end
      if pattern.is_a?(Numeric)
        statement = false unless my_arr.include? pattern
      elsif pattern.is_a?(Regexp)
        my_arr.length.times do
          statement = false unless my_arr[c].match(pattern)
          c += 1
        end
      elsif pattern.is_a?(String)
        if respond_to?(:to_s)
          statement = false unless my_arr.include? pattern
        end
      elsif pattern.is_a?(Array)
        statement = false unless my_arr.include? pattern
      elsif pattern.is_a?(TrueClass)
        statement = false unless my_arr.include? pattern
      elsif pattern.is_a?(FalseClass)
        statement = false unless my_arr.include? pattern
      else
        my_arr.length.times do
          if !my_arr[c].is_a?(pattern)
            statement = false
          else
            statement = true
            break
          end
          c += 1
        end
      end
    end
    statement
  end

  def my_count(var = nil)
    c = 0
    if block_given?
      my_each { |i| c += 1 if yield(i) }
    elsif !var.nil?
      if to_a.include? var
        to_a.length.times do |i|
          c += 1 if to_a[i] == var
        end
      end
      c
    else
      c = size
    end
    c
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || proc

    result = []
    if proc
      my_each { |x| result.push(proc.call(x)) }
    else
      my_each { |x| result.push(yield(x)) }
    end
    result
  end

  def my_inject(*arg)
    arr = is_a?(Array) ? self : to_a
    result = arg[0] if arg[0].is_a? Integer

    if arg[0].is_a?(Symbol) || arg[0].is_a?(String)
      sym = arg[0]
    elsif arg[0].is_a?(Integer)
      sym = arg[1] if arg[1].is_a?(Symbol) || arg[1].is_a?(String)
    end

    if sym
      arr.my_each { |item| result = result ? result.send(sym, item) : item }
    else
      arr.my_each { |item| result = result ? yield(result, item) : item }
    end

    result
  end
end

def multiply_els(array)
  p array.my_inject(1) { |r, i| r * i }
end
rang = Range.new(5, 10)
multiply_els(rang)
puts
# multiply_els([23, 34, 56])
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/BlockNesting
