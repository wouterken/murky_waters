# MurkyWaters

[![Murky Waters](https://img.shields.io/badge/Murky%20Waters--green.svg)](https://github.com/wouterken/murky_waters)
[![Gem Version](https://badge.fury.io/rb/murky_waters.svg)](http://badge.fury.io/rb/murky_waters)
[![Downloads](https://img.shields.io/gem/dt/murky_waters/stable.svg)](https://img.shields.io/gem/dt/murky_waters)

MurkyWaters is a simple implementation of a merkle tree backed dictionary.

You can use this as an you would any ordinary dictionary structure with the added functionality
that you can generate verifiable proofs of the dictionary structure and presence of leaf nodes in the dictionary. Proofs for individual leaves can exist with zero-knowledge of the contents of other leaves in the dictionary.

In short, this can allow you to provide proof of knowledge of some subset of a larger set of data without leaking any information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'murky_waters'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install murky_waters

## Usage

To construct a new Merkle tree backed ordered dictionary

### Basics
```ruby
    # A new, empty Merkle tree dictionary
    dict = Murky::Dict()

    # Specify a custom backing dictionary, default implementation is Hash
    dict = Murky::Dict(data: acts_like_a_dictionary)

    # Specify a custom digest class, must #respond_to?(:digest)
    dict = Murky::Dict(digest: Digest::SHA256)
```

To accesss, add and remove data to be indexed in our dict

```ruby
  dict["hello"] = "world"  # Add data
  dict.delete("hello")     # Delete data
  dict["hello"]            # Retrieve data
  dict.siblings("hello")   # => [
                           #   "\xB0\x1F0Ji\ri\xE3\xFBMI\x9FU:=\xFF\xC3t\xD1\xCA6v\x11}'Q\x8E\xCD\x16t\xF4{",
                           #   "C\xEE\x89iS$s\xA9\xBE\xCD:\xD3ob\xE5\x8C\xBC\xE3g\x04\x00\x85Z\xBE@\x8Bu\xE4(\eR\xB4",
                           #   "\xC9\xDCj6\xC3g\f\xB2\xCEr\x05\xFB\xA4[\x06\xF5--q\xFA\xA4\xE9\x95c\xB0\xC8]\xB5\xBD\x1D\xC5\x12"
                           # ]
  dict.root                # "anajKi18I3C9TlVEcU//hZsw9i4sknlYCTspTQXxCr0=\n" # The merkle root/signature of our entire dictionary contents
```

### Proofs
```ruby
  # Generate a proof that "hello" exists inside of our dictionary and a merkle root/signature for our entire dictionary contents
  dict.proof("hello")
  # => #<Murky::Proof:0x007fc9c2f1ef30
  # @digest=#<Digest::SHA256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855>,
  # @root="\x80\xF5\x9F\xFF\xAD\xC2-\x85t\xCCY\xC8\x90\xBB\x9D\xC2\x16@\x02-\x1C&k\xB8>\xA6\xC3[\x8C'I\xE6",
  # @siblings=
  #  ["\xB0\x1F0Ji\ri\xE3\xFBMI\x9FU:=\xFF\xC3t\xD1\xCA6v\x11}'Q\x8E\xCD\x16t\xF4{",
  #   "C\xEE\x89iS$s\xA9\xBE\xCD:\xD3ob\xE5\x8C\xBC\xE3g\x04\x00\x85Z\xBE@\x8Bu\xE4(\eR\xB4",
  #   "}q\x80\xE0:\xD1Am\xDB.@g\xDE\xE8u\xC1h\xD92\x8F\x19l\xAD]\x02)I\rn\xC1z\x96"],
  # @signature="\x90\xE3\xC8\xFCn\x86\x15\"\x94\x84`\xEC\xFB\xC2\xEE^;\xDD\x9B\xF1\x89\v\xE04u\r\xE4\b\xA5\xE0$l",
  # @valid=true>
  #
```

### Verification
```ruby
  # Perform a verification for a root, and a merkle path/sibling list and some value.
  It verifies that this value resides in the dictionary represented by our root signature. From this we can conclude that the size, shape and order of the tree for this merkle root are unchanged from when this proof was generated and that our value does indeed exist within the dictionary.

  # Murky.verify(root, siblings, data) # => true/false
  Murky.verify(
    root,
    siblings,
    data
  ) # => true if verification passes
```
A tree can optionally be backed by any dictionary like data structure to store the real leaf data.
The prerequisites of this structure are that:
  * It is hash-like (implements #[]= and #[])
  * It is ordered
  * It implements #keys
  * It implements #values

You can pass this structure into the constuctor of the Murky::Dict. E.g

```ruby
Murky::Dict(data: {foo: :bar})
```
### Saving and restoring proofs

Proofs can be saved to, and restored from a file.
E.g

```ruby
  dict.proof(:my_value).output("/Users/pico/Desktop/proof.txt")

  proof = Murky::Proof.from_file("/Users/pico/Desktop/proof.txt")
  proof.valid? #=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wouterken/murky_waters. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the MurkyWaters project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/murky_waters/blob/master/CODE_OF_CONDUCT.md).

