module Velo

  class Device

    attr_accessor :name, :unit_id, :product_id, :version

    def inspect()
      "#<Device #{name} version #{version.join "."}>"
    end

    alias_method :to_s, :inspect
  end

end
