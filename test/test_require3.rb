require "minitest/autorun"
require "require3"

class TestRequire3 < MiniTest::Test
  CONSTANTS = %w[Foo Bar Baz CSV]
  FILES = %w[a/b.rb a/c.rb]

  def setup
    @libroot = File.join(File.dirname(__FILE__), "lib")
    $: << @libroot
  end

  def teardown
    FILES.each { |name| $".delete("#@libroot/#{name}") }

    CONSTANTS.each do |name|
      Object.send(:remove_const, name) if Object.const_defined?(name)
    end
  end

  def test_returns_true_if_not_loaded_and_false_if_loaded
    assert_equal true, require3("a/b")
    assert_equal false, require3("a/b")
  end

  def test_without_aliases
    require3 "a/b"
    assert Object.const_defined?("A::B")
  end

  def test_with_simple_alias
    require3 "a/b" => "foo"
    assert Object.const_defined?("Foo")
    assert Object.const_defined?("A::B")
    assert_equal A::B, Foo
  end

  def test_with_glob
    require3 "a/b" => "*"

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("Bar")
    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("A::B::Bar")

    assert_equal A::B::Foo, Foo
    assert_equal A::B::Bar, Bar
  end

  def test_with_array_argument
    require3 "a/b" => %w[foo bar]

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("Bar")
    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("A::B::Bar")

    assert_equal A::B::Foo, Foo
    assert_equal A::B::Bar, Bar
  end

  def test_with_hash_aliases_using_path_style_names
    require3 "a/b" => { :foo => "foo", "a/baz" => "baz" }

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("Baz")
    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("A::Baz")

    assert_equal A::B::Foo, Foo
    assert_equal A::Baz, Baz
  end

  def test_with_hash_aliases_using_class_style_names
    require3 "a/b" => { "Foo" => "Foo", "A::Baz" => "Baz" }

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("Baz")
    assert Object.const_defined?("A::B::Foo")
    assert Object.const_defined?("A::Baz")

    assert_equal A::B::Foo, Foo
    assert_equal A::Baz, Baz
  end

  def test_relative_path_simple_alias
    Dir.chdir @libroot do
      require3 "./a/c.rb" => "foo"
    end

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("A::C")

    assert_equal A::C, Foo
  end

  def test_relative_path_using_array_argument
    Dir.chdir @libroot do
      require3 "./a/c.rb" => %w[foo]
    end

    assert Object.const_defined?("Foo")
    assert Object.const_defined?("A::C::Foo")

    assert_equal A::C::Foo, Foo
  end

  def test_removes_loaded_features_on_error
    assert_raises NameError do
      require3 "a/b" => {:bad => "foo"}
    end

    assert $".none? { |path| path.end_with?("a/b.rb") }
  end

  def test_removes_loaded_dependency_features_on_error
    assert_raises NameError do
      require3 "a/just_dependencies" => {:bad => "foo"}
    end

    assert $".none? { |path| path.end_with?("a/just_dependencies.rb") }
    assert $".none? { |path| path.end_with?("a/b.rb") }
    assert $".none? { |path| path.end_with?("a/c.rb") }
  end

  def test_does_not_remove_other_loaded_dependency_features_on_error
    require "csv"

    assert_raises NameError do
      require3 "a/b" => {:bad => "foo"}
    end

    # CSV was successfuly loaded outside require3 so make sure it's not removed by require3
    assert $".any? { |path| path.end_with?("/csv.rb") }
  end

end
