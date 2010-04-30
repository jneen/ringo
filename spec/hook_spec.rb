describe "a simple hook" do
  before :all do
    class Foo < Ringo::Model
      string :bar

      attr_reader :lol, :wtf

      before :bar= do |foo, new|
        puts "running before :bar="
        foo.instance_variable_set("@lol", new)
      end

      after :fetch_bar do |foo|
        foo.instance_variable_set("@wtf", true)
      end
    end
  end

  before :each do
    Ringo.redis.flushdb
    @foo = Foo.new
  end

  it "calls before setter hooks" do
    lambda do
      @foo.bar = "baz"
    end.should change(@foo, :lol).from(nil).to("baz")
  end

  it "calls after getter hooks" do
    @foo.bar = "baz"
    lambda do
      @foo.bar
    end.should change(@foo, :wtf).from(nil).to(true)
  end
end
