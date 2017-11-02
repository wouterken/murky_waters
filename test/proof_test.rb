require 'test_helper'
require 'murky'

class ProofTest < Minitest::Test
  def setup
    @dict = Murky::Dict(data: {
      password:       'super-secret password',
      passport_number: 4524395285424545,
      credit_card_number: 93204324324,
      puk_code: '3845',
      private_key: '2fa8ce90251d342b'
    })
    @proof1 = @dict.proof(:password)
    @proof2 = @dict.proof(:passport_number)
    @proof3 = @dict.proof(:noexist)
  end

  def test_proof_validity1
    assert @proof1.valid?
    assert @proof2.valid?
  end

  def test_proof_validity2
    refute @proof3.valid?
  end

  def test_blank_slate_verify1
    root = @proof1.root
    siblings = @proof1.siblings
    assert Murky.verify(root, siblings, 'super-secret password')
  end

  def test_blank_slate_verify2
    root = @proof2.root
    siblings = @proof2.siblings
    assert Murky.verify(root, siblings, 4524395285424545)
  end

  def test_blank_slate_verify3
    root = @proof2.root
    siblings = @proof2.siblings
    refute Murky.verify(root, siblings, 'not in the tree')
  end

  def test_write_proof
    tmpfile = Tempfile.new('foo').path
    assert File.size(tmpfile).zero?
    @proof1.output(tmpfile)
    refute File.size(tmpfile).zero?
  end

  def test_read_proof
    tmpfile = Tempfile.new('foo').path
    @proof1.output(tmpfile)
    assert Murky::Proof.from_file(tmpfile).valid?
  end
end