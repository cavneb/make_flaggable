module MakeFlaggable
  module Flagger
    extend ActiveSupport::Concern

    included do
      has_many :flaggings, :class_name => "MakeFlaggable::Flagging", :as => :flagger, :dependent => :destroy
    end

    module ClassMethods
      def flagger?
        true
      end
    end

    # Flag a +flaggable+ using the provided +flag+.
    # Raises an +AlreadyFlaggedError+ if the flagger already flagged the flaggable with the same +:flag+.
    # Raises an +InvalidFlaggableError+ if the flaggable is not a valid flaggable.
    # Raises an +InvalidFlagError+ if the flaggable does not allow the provided +:flag+ as a flag value.
    def flag!(flaggable, flag)
      check_flaggable(flaggable, flag)

      if flagged?(flaggable, flag)
        raise MakeFlaggable::Exceptions::AlreadyFlaggedError.new
      end

      Flagging.create(:flaggable => flaggable, :flagger => self, :flag => flag)
    end

    # Flag the +flaggable+, but don't raise an error if the flaggable was already flagged by the +flagger+ with the +:flag+.
    def flag(flaggable, flag)
      begin
        flag!(flaggable, flag)
      rescue Exceptions::AlreadyFlaggedError
      end
    end

    def unflag!(flaggable, flag)
      check_flaggable(flaggable, flag)

      flaggings = fetch_flaggings(flaggable, flag)

      raise Exceptions::NotFlaggedError if flaggings.empty?

      flaggings.destroy_all

      true
    end

    def unflag(flaggable, flag)
      begin
        unflag!(flaggable, flag)
        success = true
      rescue Exceptions::NotFlaggedError
        success = false
      end
      success
    end

    def flagged?(flaggable, flag)
      check_flaggable(flaggable, flag)
      fetch_flaggings(flaggable, flag).try(:first) ? true : false
    end

    private

    def fetch_flaggings(flaggable, flag)
      flaggings.where({
        :flag => flag.to_s,
        :flaggable_type => flaggable.class.to_s,
        :flaggable_id => flaggable.id
      })
    end

    def check_flaggable(flaggable, flag)
      raise Exceptions::InvalidFlaggableError unless flaggable.class.flaggable?
      raise Exceptions::InvalidFlagError unless flaggable.available_flags.include? flag.to_sym
    end
  end
end
