# MurkyWaters

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
                           #  "OLpNd02wZa5e2XMKG/8rFMUKFVUq/yy6F+c3Rd09eKc=\n",
                           #  "GySoYGQjpOMz62o7F56Al67mVjB9IP5GxpBmbQvp3wc=\n"
                           # ]

  dict.root                # "anajKi18I3C9TlVEcU//hZsw9i4sknlYCTspTQXxCr0=\n" # The merkle root/signature of our entire dictionary contents
```

### Proofs
```ruby
  # Generate a proof that "hello" exists inside of our dictionary and a merkle root/signature for our entire dictionary contents
  dict.proof("hello")
  #  => #<Murky::Proof:0x007f9d1ef5c810
  # @digest=
  #  #<Digest::SHA256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855>,
  # @root="anajKi18I3C9TlVEcU//hZsw9i4sknlYCTspTQXxCr0=\n",
  # @siblings=
  #  ["47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
  #   "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
  #   "qZDReXdlGqrjRUZy3nSfWXY6y8KYxwb+A7K6/Xg7Nxc=\n",
  #   "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
  #   "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
  #   "jqwjgWe5ZVi9USkRcycxwiXtFtSLbycfKHJRJ8Scm3A=\n",
  #   "ujOfV44N03rF/+m6+eONFRPJYmstEnhsh2YcKdIUyVU=\n"],
  # @valid=true>
```
### Verification
```ruby
  # Perform a verification for a root, and a merkle path/sibling list and some value.
  It verifies that this value resides in the dictionary represented by our root signature. From this we can conclude that the size, shape and order of the tree for this merkle root are unchanged from when this proof was generated and that our value does indeed exist within the dictionary.

  # Murky.verify(root, siblings, value) # => true/false
  Murky.verify(
    "EpU7Zx9tzTCGGyQtNQgC5Iu8IxRlXFjwG7KCjqfuRwI=\n",
    [
      "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
      "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
      "qZDReXdlGqrjRUZy3nSfWXY6y8KYxwb+A7K6/Xg7Nxc=\n",
      "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
      "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=\n",
      "jqwjgWe5ZVi9USkRcycxwiXtFtSLbycfKHJRJ8Scm3A=\n",
      "ujOfV44N03rF/+m6+eONFRPJYmstEnhsh2YcKdIUyVU=\n"
    ],
    "world"
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

