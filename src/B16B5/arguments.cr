require "option_parser"

class Argument
  getter input : IO
  @key : IO?
  getter output : IO
  # getter ascii : Bool
  getter mode : Symbol
  getter rounds : Int32

  def key : IO
    raise "Key not set !" if @key.nil?
    @key.as(IO)
  end

  def initialize
    @input = STDIN
    @output = STDOUT
    @ascii = false
    @mode = :encrypt
    @rounds = 8

    OptionParser.parse! do |parser|
      parser.banner = "Usage: B16B5 [arguments]"
      parser.on("-i PATH", "--input=PATH", "Path to the input file to read") { |path| @input = File.open(path) }
      parser.on("-k PATH", "--keyfile=PATH", "Path to the key file to read") { |path| @key = File.open(path) }
      parser.on("-o PATH", "--output=PATH", "Path to the output file to write") { |path| @output = File.open(path, "w") }
      parser.on("-r COUNT", "--rounds=COUNT", "Path to the output file to write") { |count| @rounds = count.to_i }
      # parser.on("-a", "--ascii", "Enable ascii output") { @ascii = true }
      parser.on("-d", "--decrypt", "Decrypt") { @mode = :decrypt }
      parser.on("-h", "--help", "Show this help") { puts parser; exit }
    end
  end
end
