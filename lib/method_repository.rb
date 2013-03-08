require_relative "method_repository/version"

module MethodRepository
  def self.included(base)
    base.instance_variable_set(:@targets,    {})
    base.instance_variable_set(:@extendable, [])
    base.instance_variable_set(:@includable, [])
    base.extend(ModuleMethods)
  end

  class NotPermittedError < RuntimeError; end

  module ModuleMethods
    def extended(base)
      klass_name = base.class.to_s == 'Class' ? base.to_s : base.class.to_s

      if !@extendable.empty? && !@extendable.include?(klass_name)
        raise MethodRepository::NotPermittedError.new("Extending #{klass_name} by this module is not permitted")
      end

      if (methods = @targets[klass_name])
        base.singleton_class.class_eval do
          methods.each do |method|
            define_method method[:name], method[:block]
          end
        end
      end
    end

    def included(base)
      klass_name = base.to_s

      if !@includable.empty? && !@includable.include?(klass_name)
        raise MethodRepository::NotPermittedError.new("Including #{klass_name} by this module is not permitted")
      end

      if (methods = @targets[klass_name])
        base.class_eval do
          methods.each do |method|
            define_method method[:name], method[:block]
          end
        end
      end
    end

    def extendable_by(*klasses)
      @extendable.push(*klasses)
    end

    def includable_by(*klasses)
      @includable.push(*klasses)
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
