require "syro"

class Cuba < Syro::Deck
  def self.call(env)
    return prototype.call(env)
  end

  def self.use(middleware, *args, &block)
    app.use(middleware, *args, &block)
  end

  def self.prototype
    @prototype ||= app.to_app
  end

  def self.app
    @app ||= Rack::Builder.new
  end

  def self.reset!
    @app = @prototype = nil
  end

  def self.define(&code)
    app.run(Syro.new(self, &code))
  end

  def self.settings
    @settings ||= {}
  end

  def self.deepclone(obj)
    return Marshal.load(Marshal.dump(obj))
  end

  def self.inherited(child)
    child.settings.replace(deepclone(settings))
  end

  def settings
    return self.class.settings
  end
end
