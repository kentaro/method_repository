require 'spec_helper'

describe MethodRepository do
  module Repository
    include MethodRepository

    insert :method1, in: %w[Foo Bar] do; end
    insert :method2, in: %w[Baz]     do; end
  end

  class Foo; end
  class Bar; end
  class Baz; end
  class Qux; end

  describe '.insert' do
    it {
      expect {
        module Repository
          insert :method3
        end
      }.to raise_error(
        ArgumentError,
        "`:in' parameter is required",
      )
    }
  end

  describe '.extended' do
    context 'when classes are extended' do
      before {
        Foo.extend(Repository)
        Bar.extend(Repository)
        Baz.extend(Repository)
        Qux.extend(Repository)
      }

      it {
        expect(Foo.respond_to?(:method1)).to be true
        expect(Bar.respond_to?(:method1)).to be true
        expect(Baz.respond_to?(:method1)).to be false
        expect(Qux.respond_to?(:method1)).to be false

        expect(Foo.respond_to?(:method2)).to be false
        expect(Bar.respond_to?(:method2)).to be false
        expect(Baz.respond_to?(:method2)).to be true
        expect(Qux.respond_to?(:method1)).to be false
      }
    end

    context 'when objects are extended' do
      let(:foo) { Foo.new }
      let(:bar) { Bar.new }
      let(:baz) { Baz.new }
      let(:qux) { Qux.new }

      before {
        foo.extend(Repository)
        bar.extend(Repository)
        baz.extend(Repository)
        qux.extend(Repository)
      }

      it {
        expect(foo.respond_to?(:method1)).to be true
        expect(bar.respond_to?(:method1)).to be true
        expect(baz.respond_to?(:method1)).to be false
        expect(qux.respond_to?(:method1)).to be false

        expect(foo.respond_to?(:method2)).to be false
        expect(bar.respond_to?(:method2)).to be false
        expect(baz.respond_to?(:method2)).to be true
        expect(qux.respond_to?(:method1)).to be false
      }
    end
  end

  describe '.included' do
    before {
      Foo.send(:include, Repository)
      Bar.send(:include, Repository)
      Baz.send(:include, Repository)
      Qux.send(:include, Repository)
    }

    it {
      expect(Foo.new.respond_to?(:method1)).to be true
      expect(Bar.new.respond_to?(:method1)).to be true
      expect(Baz.new.respond_to?(:method1)).to be false
      expect(Qux.new.respond_to?(:method1)).to be false

      expect(Foo.new.respond_to?(:method2)).to be false
      expect(Bar.new.respond_to?(:method2)).to be false
      expect(Baz.new.respond_to?(:method2)).to be true
      expect(Qux.new.respond_to?(:method1)).to be false
    }
  end
end
