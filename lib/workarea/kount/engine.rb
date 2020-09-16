module Workarea
  module Kount
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Kount
    end
  end
end
