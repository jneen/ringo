describe "Ringo::RedisZSet" do
  before :each do
    Ringo.redis.flushdb
    class Foo
      scored_set :bar, :of => :json_objects do |hsh|
        hsh["baz"]
      end
    end
  end

  it "does something" do
    foo = Foo.new
    foo.bar.add({"baz" => 500})
    foo.bar.all.should == [
      {"baz" => 500}
    ]
    foo.bar.add({"baz" => 250, "zot" => [1,2,3]})
    foo.bar.all.should == [
      {"baz" => 250, "zot" => [1,2,3]},
      {"baz" => 500},
    ]
    foo.bar.add({"baz" => 300, "zug" => "lol"})
    foo.bar.all.should == [
      {"baz" => 250, "zot" => [1,2,3]},
      {"baz" => 300, "zug" => "lol"},
      {"baz" => 500},
    ]
    foo.bar.between(100, 600).should == foo.bar.all
    foo.bar.between(260, 510).should == [
      {"baz" => 300, "zug" => "lol"},
      {"baz" => 500},
    ]
  end
end
