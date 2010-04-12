require 'ringo'

describe Ringo::Model::ForeignKeyField do
  before :all do
    class Foo < Ringo::Model
      string :bar
    end

    class Lol < Ringo::Model
      string :wtf
    end
  end

  it "can set a foreign key" do
    foo = Foo.new
    lol = Lol.new

    lambda do
      class Foo
        has_one Lol
      end
    end.should_not raise_error
    foo.lol.should be_nil
    foo.lol = Lol.new
    foo.lol.should be_a Lol
    foo.lol.wtf = "omg"
    foo.lol.wtf.should == "omg"
    Foo[foo.id].lol.wtf.should == "omg"

    lol.foo.should be_a Foo
    lol.foo.should == foo
  end
end
