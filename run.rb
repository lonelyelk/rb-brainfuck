#!/usr/bin/env ruby

class BrainFuck

  BUFFER = 30000
  CHR = 255

  ALIAS = {">" => :gt,
           "<" => :lt,
           "+" => :pl,
           "-" => :mn,
           "." => :pt,
           "," => :cm,
           "[" => :lp,
           "]" => :rp}

  def initialize(prog)
    @program = prog.gsub(/[^>^<^+^\-^.^,^\[^\]]/, "")
  end

  def run
    @breakpoint = 0
    @memory = 0.chr * BUFFER
    @index = 0
    if @program.length > 0
      while @breakpoint < @program.length
        send(ALIAS[@program[@breakpoint].chr])
        @breakpoint += 1
      end
    end
  end

  def gt
    @index += 1
    @index %= BUFFER
  end

  def lt
    @index -= 1
    @index %= BUFFER
  end

  def pl
    val = @memory[@index] + 1
    @memory[@index] = (val % CHR).chr
  end

  def mn
    val = @memory[@index] - 1
    @memory[@index] = (val % CHR).chr
  end

  def pt
    print @memory[@index].chr
  end

  def cm
    c = STDIN.getc
    print c.chr
    @memory[@index] = c.chr
    STDIN.getc unless c == 10
  end

  def lp
    if @memory[@index] == 0
      flag = 0
      new_bp = @breakpoint
      while flag >= 0
        new_bp += 1
        raise "Can't find ']' for '[' in position #{@breakpoint}" if new_bp >= @program.length
        case @program[new_bp].chr
          when "["
            flag += 1
          when "]"
            flag -= 1
        end
      end
      @breakpoint = new_bp - 1
    end
  end

  def rp
    if @memory[@index] != 0
      flag = 0
      new_bp = @breakpoint
      while flag >= 0
        new_bp -= 1
        raise "Can't find '[' for ']' in position #{@breakpoint}" if new_bp < 0
        case @program[new_bp].chr
          when "]"
            flag += 1
          when "["
            flag -= 1
        end
      end
      @breakpoint = new_bp - 1
    end
  end
end

BrainFuck.new(File.read(ARGV[0])).run
