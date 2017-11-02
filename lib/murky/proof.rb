module Murky
  class Proof
    attr_reader :root, :siblings, :signature

    FILE_HEADER  = "#{?= * 20} BEGIN MURKY PROOF #{?= * 20} "
    FILE_FOOTER  = "#{?= * 20} BEGIN MURKY PROOF #{?= * 20} "
    INPUT_REGEXP = %r{#{FILE_HEADER}\n(.*?)\n#{FILE_FOOTER}}m

    def initialize(root:, siblings:, signature:, digest:)
      @digest    = digest
      @root      = root
      @siblings  = siblings
      @signature = signature
      @valid = root == siblings.reduce(signature) do |mem, sibling|
        sign Murky.xor(mem,sibling)
      end
    end

    def sign(value)
      @digest.digest(value.to_s)
    end

    def valid?
      @valid
    end

    def self.base64_encode(value)
      Base64.encode64(value)
    end

    def self.base64_decode(value)
      Base64.decode64(value)
    end

    def output(filename)
      IO.write(
        filename,
        "#{FILE_HEADER}\n" <<
        (
          [self.class.base64_encode(root)] +
          siblings.map(&self.class.method(:base64_encode)) +
          [self.class.base64_encode(@signature)]
        ).join <<
        "#{FILE_FOOTER}"
      )
    end

    def self.from_file(filename, digest: Digest::SHA256)
      root, *siblings, signature = IO.read(filename)[INPUT_REGEXP, 1].split("\n").map(&method(:base64_decode))
      Murky::Proof.new(root: root, siblings: siblings, signature: signature, digest: digest)
    end
  end
end