class Shoes
  module Swt
    class SwtButton
      include Common::Remove
      include Common::Toggle
      include Common::UpdatePosition
      include ::Shoes::BackendDimensionsDelegations

      attr_reader :parent, :real, :dsl

      def initialize(dsl, parent, type)
        @dsl = dsl
        @parent = parent

        @type = type
        @real = ::Swt::Widgets::Button.new(@parent.real, @type)

        yield(@real) if block_given?

        set_size
      end

      def eval_block blk
        blk.call @dsl
      end

      def focus
        @real.set_focus
      end

      def click blk
        @listener_array = @real.getListeners ::Swt::SWT::Selection
        if @listener_array.length > 0
          @old_listener = @listener_array[0]
          @real.removeListener ::Swt::SWT::Selection, @old_listener
        end
        @real.addSelectionListener { eval_block blk }
      end

      def enabled(value)
        @real.enable_widget value
      end

      private
      def set_size
        @real.pack
        @dsl.element_width ||= @real.size.x
        @dsl.element_height ||= @real.size.y
        @real.setSize @dsl.element_width, @dsl.element_height
      end
    end
  end
end
