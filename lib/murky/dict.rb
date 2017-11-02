module Murky
  class Dict
    attr_reader :root

    def initialize(data: {}, digest: Digest::SHA256.new)
      @root    = nil
      @digest  = digest
      @changed = !data.size.zero?
      define_singleton_method(:data, ->{data})
    end

    def keys
      data.keys
    end

    def values
      data.values
    end

    def include?(key)
      data.include?(key)
    end

    def height
      Math.ceil(Math.log(@size, 2))
    end

    def sign(value)
      @digest.digest(value.to_s)
    end

    def []=(key, value)
      @changed = true
      data[key] = value
    end

    def [](key)
      data[key]
    end

    def delete(key)
      @changed = true
      data.delete(key)
    end

    def root
      @root = @changed ? compute_root : @root
    end

    def proof(key)
      Proof.new({
        root:      root,
        siblings:  siblings(key),
        signature: sign(data[key]),
        digest:    @digest
      })
    end

    def siblings(key)
      return [] if !include?(key)
      signature = sign(data[key])
      siblings = []
      compute_root do |left_sig, right_sig|
        case
        when left_sig  === signature then siblings << right_sig
        when right_sig === signature then siblings << left_sig
        else next
        end
        signature = sign(Murky.xor(left_sig,right_sig))
      end
      return siblings
    end

    def to_s
      "Murky::Dict(#{data.to_s})"
    end

    def inspect
      "Murky::Dict(#{data.inspect})"
    end

    private
      def compute_root(values=self.values, from_bottom=0, &block)
        if values.length == 1
          @changed = false
          return sign(values[0])
        end
        compute_root(values.each_slice(2).map do |left, right|
          ls, rs = sign(left),sign(right)
          block[ls, rs] if block_given?
          Murky.xor(ls, rs)
        end, from_bottom + 1, &block)
      end
  end

  module_function
    def Dict(*args)
      Dict.new(*args)
    end
end