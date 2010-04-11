require 'ringo'

describe Ringo::Model, "model" do
  it "makes models" do
    class Foo < Ringo::Model
      string :bar
      int :baz
    end

    a = Foo.new

    a.bar.should be_nil
    a.baz.should be_nil
    a.id.should be_nil

    a.bar = "bar"
    a.baz = 7

    a.save!

    a.id.should be_a Fixnum
  end
end
