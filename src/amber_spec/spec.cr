module Spec
  class_property system_test : System::Test?

  before_each do
    self.system_test.try &.before
  end

  after_each do
    self.system_test.try &.after
  end

  def self.run
    selenium = SeleniumServer.boot
    sleep 2

    start_time = Time.now
    at_exit do
      elapsed_time = Time.now - start_time
      Spec::RootContext.print_results(elapsed_time)

      if selenium
        selenium.not_nil!.kill
        sleep 2
      end

      exit 1 unless Spec::RootContext.succeeded
    end
  end
end
