module DatabaseCleanerPlugin
  def before_setup
    begin
      super
    rescue NoMethodError
      # we ain't got no super
    end

    DatabaseCleaner.start
  end

  def after_teardown
    begin
      super
    rescue NoMethodError
      # we ain't got no super
    end

    DatabaseCleaner.clean
  end
end
