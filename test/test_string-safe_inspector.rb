# coding: utf-8
# frozen_string_literal: true

require_relative 'helper'

class TestStringSafeInspector < Test::Unit::TestCase
  class MyPlainObject < BasicObject
  end

  class SpecialInspectableObject < BasicObject
    def inspect
      "I'm special :)"
    end
  end

  class EvilRasingObject < BasicObject
    def inspect
      raise Exception, "I'm evil :)"
    end
  end

  class EvilReturnedObject < BasicObject
    def inspect
      BasicObject.new
    end
  end

  class EvilNullableObject < BasicObject
    def inspect
      nil
    end
  end

  def test_versioning
    assert do
      String::SafeInspector::VERSION.instance_of?(String)
    end

    assert do
      String::SafeInspector::VERSION.frozen?
    end

    assert do
      Gem::Version.correct?(String::SafeInspector::VERSION)
    end
  end

  data(
    'Integer instance' => ['42', 42],
    'Array class' => ['Array', Array],
    'Array instance' => ['[]', []],
    'BasicObject class' => ['BasicObject', BasicObject],
    'String instance'  => ['" a string "', ' a string '],
    'nil' => ['nil', nil],
    'true' => ['true', true],
    'false' => ['false', false],
    'empty string' => ['""', '']
  )
  def test_inspection_for_typical_objects(expected_and_target)
    expected, target = *expected_and_target
    assert_equal(expected, String::SafeInspector.inspect_for(target))
  end

  data(
    'Integer instance' => 42,
    'Array class' => Array,
    'Array instance' => [],
    'BasicObject class' => BasicObject,
    'String instance'  => ' a string ',
    'nil' => nil,
    'true' => true,
    'false' => false,
    'empty string' => '',
    'BasicObject instance' => BasicObject.new,
    'The object has special #inspect' => SpecialInspectableObject.new,
    'The object does not have #inspect' => MyPlainObject.new,
    'The #inspect raises exception :<' => EvilRasingObject.new,
    'The #inspect returns `non string`' =>  EvilReturnedObject.new,
    'The #inspect returns `nil`' =>  EvilNullableObject.new
  )
  def test_additional_signature(target)
    assert(!String::SafeInspector.inspect_for(target).frozen?)
    assert_not_same(String::SafeInspector.inspect_for(target), String::SafeInspector.inspect_for(target))
  end

  def test_for_basic_object
    assert_match(/\A#<BasicObject:0x\w{16}>\z/, String::SafeInspector.inspect_for(BasicObject.new))
  end

  def test_for_special_objects
    assert_equal("I'm special :)", String::SafeInspector.inspect_for(SpecialInspectableObject.new))
  end

  def test_for_no_methods
    assert_match(/\A#<#{self.class.name}::MyPlainObject:0x\w{16}>\z/, String::SafeInspector.inspect_for(MyPlainObject.new))
  end

  def test_for_raising_exception
    assert_match(/\A#<#{self.class.name}::EvilRasingObject:0x\w{16}>\z/, String::SafeInspector.inspect_for(EvilRasingObject.new))
  end

  def test_for_return_basic_object
    assert_match(/\A#<#{self.class.name}::EvilReturnedObject:0x\w{16}>\z/, String::SafeInspector.inspect_for(EvilReturnedObject.new))
  end

  def test_for_return_nil
    assert_match(/\A#<#{self.class.name}::EvilNullableObject:0x\w{16}>\z/, String::SafeInspector.inspect_for(EvilNullableObject.new))
  end
end
