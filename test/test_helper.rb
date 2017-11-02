require 'simplecov'
SimpleCov.start do
  add_group "Lib", "lib"
end

require 'minitest/autorun'
