require 'murky/version'
require 'murky/dict'
require 'murky/proof'
require 'base64'

module Murky
  module_function
    def verify(root, siblings, value, digest: Digest::SHA256.new)
      Proof.new(
        root: root,
        siblings: siblings,
        signature: digest.digest(value.to_s),
        digest: digest
      ).valid?
    end

    def xor(s1, s2)
      s2, s1 = [s1, s2].sort_by(&:bytesize)
      s1.bytes.zip(s2.bytes).map do |x,y|
        ((x || 0) ^ (y || 0)).chr
      end.join
    end
end
