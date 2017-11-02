require 'test_helper'
require 'murky'

class DictTest < Minitest::Test
  def setup
    @dict = Murky::Dict(data: {
      password:       'super-secret password',
      passport_number: 4524395285424545,
      credit_card_number: 93204324324,
      puk_code: '3845',
      private_key: '2fa8ce90251d342b'
    })
  end

  def test_access1
    assert_equal @dict[:password], 'super-secret password'
  end

  def test_access2
    assert_nil @dict[:noexist]
    previous_root = @dict.root
    @dict[:noexist] = false
    assert_equal @dict[:noexist], false
    refute_nil @dict.root
    refute_equal @dict.root, previous_root
  end

  def test_insert
    previous_root = @dict.root
    @dict[43] = 39
    assert_equal @dict[43], 39
    refute_nil @dict.root
    refute_equal @dict.root, previous_root
  end

  def test_delete
    assert_equal @dict[:password], 'super-secret password'
    @dict.delete(:password)
    assert_nil @dict[:password]
    refute_nil @dict.root
  end

  def test_proof_validity1
    assert_true @dict.proof(:password).valid?
  end

  def test_proof_validity1
    refute @dict.proof(:no_exist).valid?
  end

  def test_siblings
    assert_equal @dict.siblings(:password).length, Math.log(@dict.size, 2).ceil
  end

  def test_height
    assert_equal @dict.height, Math.log(@dict.size, 2).ceil
  end

  def test_equality1
    assert_equal @dict, Murky::Dict(data: @dict.data.dup)
  end

  def test_equality2
    refute_equal Murky::Dict(), Murky::Dict(data: @dict.data.dup)
  end

  def test_class_constructor1
    assert_equal Murky::Dict.new(data: @dict.data.dup), Murky::Dict(data: @dict.data.dup)
  end

  def test_class_constructor
    assert_equal Murky::Dict.new(), Murky::Dict()
  end
end