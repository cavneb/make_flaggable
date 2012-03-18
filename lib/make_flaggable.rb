require 'make_flaggable/flagging'
require 'make_flaggable/flaggable'
require 'make_flaggable/flagger'
require 'make_flaggable/exceptions'

module MakeFlaggable
  def flaggable?
    false
  end

  def flagger?
    false
  end

  # Specify a model as flaggable.
  # Required options flag names to allow flagging of with those flag types
  #
  # Example:
  # class Article < ActiveRecord::Base
  #   make_flaggable :inappropriate, :spam, :favorite
  # end
  def make_flaggable(*flags)
    raise MakeFlaggable::Exceptions::MissingFlagsError.new if flags.empty?
    @flags = flags.map!(&:to_sym)
    # Add available_flags as an instance method
    define_method(:available_flags) { flags }
    # Add available_flags as a class method
    instance_eval { def available_flags; @flags; end }
    include Flaggable
  end

  # Specify a model as flagger.
  #
  # Example:
  # class User < ActiveRecord::Base
  #   make_flagger
  # end
  def make_flagger
    include Flagger
  end
end

ActiveRecord::Base.extend MakeFlaggable
