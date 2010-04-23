require 'ringo'

describe "A Ringo List" do
  before :each do
    Ringo.redis.flushdb
    class Foo
      list :bar, :of => :integers
    end
    @foo = Foo.new
    @ref_foo = Foo[@foo.id]
  end

  it "starts out empty" do
    @foo.bar.should be_empty
    @foo.bar.all.should == []
  end

  it "pushes, pops, shifts, unshifts" do
    @foo.bar << 6
    @foo.bar << 7
    @foo.bar << 8
    @ref_foo.bar.pop.should == 8
    @foo.bar.pop.should == 7
    @foo.bar.unshift 5
    @ref_foo.bar.unshift 4
    @foo.bar.unshift 3
    @foo.bar.shift.should == 3
    @ref_foo.bar.shift.should == 4
    @foo.bar.pop.should == 6
    @ref_foo.all.should == [5]
  end

  it "looks up by index" do
    (0..10).each do |i|
      @foo.bar << i
    end
    (0..10).each do |i|
      @foo.bar[i].should == i
    end
  end

  it "slices" do
    (0..10).each do |i|
      @foo.bar << i
    end

    @foo.to_a.should == [0,1,2,3,4,5,6,7,8,9,10]
    @foo[0..5].should == [0,1,2,3,4,5]
    @foo[5..-1].should == [5,6,7,8,9,10]
    @foo[7..-2].should == [7,8,9]
  end
end
