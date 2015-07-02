module SystemBrowser
  class Behaviour
    DEFAULT_INSPECT = /#<(?:Module|Class):(0x[0-9a-f]+)>/

    def self.from_str(behaviour_str)
      self.new(behaviour_str).extract
    end

    def initialize(behaviour_str)
      @behaviour_str = behaviour_str
      @sn = SystemNavigation.default
    end

    def extract
      behaviour = eval(@behaviour_str)

      if behaviour.nil? && @behaviour_str.match(DEFAULT_INSPECT)
        self.find_behaviour_by_object_id(Integer($1))
      else
        behaviour
      end
    end

    protected

    def find_behaviour_by_object_id(behaviour_id)
      @sn.all_objects.find { |obj| (obj.__id__ << 1) == behaviour_id  }
    end
  end
end
