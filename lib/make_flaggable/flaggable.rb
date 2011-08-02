module MakeFlaggable
  module Flaggable
    extend ActiveSupport::Concern

    included do
      has_many :flaggings, :class_name => "MakeFlaggable::Flagging", :as => :flaggable, :dependent => :destroy
    end

    module ClassMethods
      def flaggable?
        true
      end
    end

    def flaggings(flag = nil)
      if flag.nil?
        flaggings
      else
        flaggings.where(:flag => flag.to_s)
      end
    end

    def flagged?(flag = nil)
      if flag.nil?
        flaggings.count > 0
      else
        flaggings.where(:flag => flag.to_s).count > 0
      end
    end

    def flagged_by?(flagger, flag)
      flagger.flagged?(self, flag)
    end
  end
end
