# coding: us-ascii
# frozen_string_literal: true

# Copyright (C) 2021 Kenichi Kamiya

class String
  # Get `#inspect` without `exception` and `nil` possibilities
  module SafeInspector
    # Used when there is nothing that can be done
    FINAL_FALLBACK = '"#<UninspectableObject:?>'

    # Might be unusable when https://bugs.ruby-lang.org/issues/12164 selects changing spec direction
    BUILTIN_INSPECT_METHOD = Kernel.instance_method(:inspect)

    private_constant :FINAL_FALLBACK, :BUILTIN_INSPECT_METHOD

    # @return [String]
    def self.inspect_for(object)
      first_choice = begin
        String.try_convert(object.inspect)
      rescue Exception
        nil
      end

      (first_choice || second_choice_for(object) || fallback_for(object)).dup
    end

    # @return [String, nil]
    private_class_method def self.second_choice_for(object)
      String.try_convert(BUILTIN_INSPECT_METHOD.bind_call(object))
    rescue Exception
      nil
    end

    # @return [String]
    private_class_method def self.fallback_for(object)
      # This implementation used `RSpec::Support::ObjectFormatter::UninspectableObjectInspector` as a reference, thank you!
      # ref: https://github.com/kachick/times_kachick/issues/97
      # Pry looks to do similar way too :) https://github.com/pry/pry/blob/0aae8c94ad03a732659ed56dcd5088469a15eebf/lib/pry/color_printer.rb#L55-L64
      singleton_class = class << object; self; end
      begin
        klass = singleton_class.ancestors.detect { |ancestor| !ancestor.equal?(singleton_class) }
        "#<#{klass}:#{'%#016x' % (object.__id__ << 1)}>"
      rescue Exception
        FINAL_FALLBACK
      end
    end
  end
end

require_relative 'safe_inspector/version'
