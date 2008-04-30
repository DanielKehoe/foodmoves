$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'test/unit'
require 'phonemic_password'

class PasswordGeneratorTest < Test::Unit::TestCase
  
  def test_generates_passwords
    assert_not_nil PhonemicPassword.generate(8)
  end
  
end