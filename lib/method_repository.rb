require_relative "method_repository/version"

module MethodRepository
  def self.included(base)
    base.instance_variable_set(:@targets, {})
    base.extend(ModuleMethods)
  end

  module ModuleMethods
    def extended(base)
      klass_name = base.class.to_s == 'Class' ? base.to_s : base.class.to_s

      if (methods = @targets[klass_name])
        base.singleton_class.class_eval do
          methods.each do |method|
            define_method method[:name], method[:block]
          end
        end
      end
    end

    def included(base)
      if (methods = @targets[base.to_s])
        base.class_eval do
          methods.each do |method|
            define_method method[:name], method[:block]
          end
        end
      end
    end

    def insert(name, klasses = {}, &block)
      if !klasses[:in]
        raise ArgumentError.new("`:in' parameter is required")
      end

      klasses[:in].each do |klass|
        @targets[klass] ||= []
        @targets[klass] << {
          name:  name,
          block: block,
        }
      end
    end
  end
end
