
# parameters:
#  output     => the formatted to use
#  backtrace  => number of lines, nil =  everything
guard 'bacon', :output => "BetterOutput", :backtrace => nil do
  watch(%r{^lib/grape/(.+)\.rb$})     { |m| "specs/unit/#{m[1]}_spec.rb" }
  watch(%r{specs/.+\.rb$})
end
