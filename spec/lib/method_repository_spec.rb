require_relative '../spec_helper'

describe MethodRepository do
  module Extendable
    include MethodRepository

    extendable_by 'Hoge', 'Piyo'
  end

  module Includable
    include MethodRepository

    includable_by 'Hoge', 'Piyo'
  end

  module Repository
    include MethodRepository

    insert :method1, in: %w[Foo Bar] do; end
    insert :method2, in: %w[Baz]     do; end
  end

  class Hoge; end
  class Fuga; end
  class Piyo; end

  class Foo; end
  class Bar; end
  class Baz; end
  class Qux; end

  describe '.extendable_by' do
    context 'when classes are permitted as extendable' do
      before {
        Hoge.extend(Extendable)
        Piyo.extend(Extendable)
      }

      it {
        expect(Hoge).to be_a_kind_of Extendable
        expect(Piyo).to be_a_kind_of Extendable
      }
    end

    context 'when classes are not permitted as extendable' do
      it {
        expect {
          Fuga.extend(Extendable)
        }.to raise_error(MethodRepository::NotPermittedError)
      }
    end
  end

  describe '.includable_by' do
    context 'when classes are permitted as includable' do
      before {
        Hoge.send(:include, Includable)
        Piyo.send(:include, Includable)
      }

      it {
        expect(Hoge.new).to be_a_kind_of Includable
        expect(Piyo.new).to be_a_kind_of Includable
      }
    end

    context 'when classes are not permitted as includable' do
      it {
        expect {
          Fuga.send(:include, Includable)
        }.to raise_error(MethodRepository::NotPermittedError)
      }
    end
  end

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
        expect(Qux.respond_to?(:method2)).to be false
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
        expect(qux.respond_to?(:method2)).to be false
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
      expect(Qux.new.respond_to?(:method2)).to be false
    }
  end

  describe '.includable_by' do
    context 'when classes'
  end
end
