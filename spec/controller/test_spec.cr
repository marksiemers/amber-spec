require "../spec_helper"

class TestCase < Spec::ControllerTestCase
end

describe Spec::ControllerTestCase do
  subject = TestCase.new

  describe "#get" do
    it "execute with one argument" do
      puts subject.get("/posts")
    end
  end

  describe "#head" do
    it "execute with one argument" do
      puts subject.head("/posts")
    end
  end

  describe "#post" do
    it "execute with one argument" do
      puts subject.post("/posts")
    end
  end

  describe "#put" do
    it "execute with one argument" do
      puts subject.put("/posts/1")
    end
  end

  describe "#patch" do
    it "execute with one argument" do
      puts subject.patch("/posts/1")
    end
  end

  describe "#delete" do
    it "execute with one argument" do
      puts subject.delete("/posts/1")
    end
  end

end
