module RMExtensions
  module TableView

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def cell_id(cell_id)
        @cell_id = cell_id
      end

      def table_footer(view, opts = {})
        @table_footer = {
          view: view,
          height: opts[:height] || 50
        }
      end

      def table_header(view, opts = {})
        @table_header = {
          view: view,
          height: opts[:height] || 50
        }
      end

      def table_view(view)
        @table_view = view
      end

    end

    def viewDidLoad
      super
      setup_table_view
      self.on_render if self.respond_to?(:on_render)
    end

    def setup_table_view
      @cell_id = self.class.instance_variable_get(:@cell_id)
      @table_footer = self.class.instance_variable_get(:@table_footer)
      @table_header = self.class.instance_variable_get(:@table_header)
      @table_view = nil
      table_view = self.class.instance_variable_get(:@table_view)

      if self.respond_to?(:tableView)
        @table_view = tableView
      else
        return nil if table_view.nil?
        @table_view = self.send(table_view) if self.respond_to?(table_view)

        if @table_view
          @table_view.delegate = self
          @table_view.dataSource = self
        end
      end

      @table_collection = []
    end

    def table_collection
      @table_collection
    end

    def table_collection=(table_collection)
      @table_collection = table_collection
      @table_view.reloadData unless @table_view.nil?
    end

    def tableView(table_view, numberOfRowsInSection:section)
      @table_collection.length
    end

    def tableView(table_view, cellForRowAtIndexPath:index_path)
      item = @table_collection[index_path.row]
      cell = table_view.dequeueReusableCellWithIdentifier(@cell_id)

      cell.model = item if cell.respond_to?(:model=)
      cell.on_render if cell.respond_to?(:on_render)
      cell.apply_bindings if cell.bindings

      cell.layer.shouldRasterize = true
      cell.layer.rasterizationScale = UIScreen.mainScreen.scale

      cell
    end

    def tableView(table_view, viewForFooterInSection:section)
      return if @table_footer.nil?
      self.send(@table_footer[:view])
    end

    def tableView(table_view, heightForFooterInSection:section)
      return 0 if @table_footer.nil?
      @table_footer[:height]
    end

    def tableView(table_view, viewForHeaderInSection:section)
      return if @table_header.nil?
      self.send(@table_header[:view])
    end

    def tableView(table_view, heightForHeaderInSection:section)
      return 0 if @table_header.nil?
      @table_header[:height]
    end

    def scrollViewWillBeginDragging(scroll_view)
      unless @table_view.nil?
        @table_view.visibleCells.each do |cell|
          cell.scroll_start if cell.respond_to?(:scroll_start)
        end
      end
    end

    def scrollViewDidEndDecelerating(scroll_view)
      unless @table_view.nil?
        @table_view.visibleCells.each do |cell|
          cell.scroll_stop if cell.respond_to?(:scroll_stop)
        end
      end
    end

  end
end