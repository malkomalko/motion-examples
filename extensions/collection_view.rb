module RMExtensions
  module CollectionView

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def cell_class(cell_class)
        @cell_class = cell_class
      end

    end

    def viewDidLoad
      super

      @cell_class = self.class.instance_variable_get(:@cell_class)
      @cell_id = @cell_class.to_s

      setup_collection_view

      self.on_render if self.respond_to?(:on_render)
    end

    def setup_collection_view
      layout = UICollectionViewFlowLayout.alloc.init

      @collection_view = UICollectionView.alloc.initWithFrame(
        self.view.frame, collectionViewLayout:layout)

      @collection_view.tap do |cv|
        cv.registerClass(@cell_class, forCellWithReuseIdentifier:@cell_id)
        cv.dataSource = self
        cv.delegate = self
        cv.allowsSelection = true
        cv.allowsMultipleSelection = false
      end

      self.view.addSubview(@collection_view)

      if using_rmq && Object.const_defined?(:CollectionViewsStylesheet)
        rmq.stylesheet = CollectionViewsStylesheet
        style = "collection_#{@cell_class.to_s.underscore}".to_sym
        rmq(@collection_view).apply_style(style)
      end

      @collection_view_data = []
    end

    def collection_view_data
      @collection_view_data
    end

    def collection_view_data=(collection_view_data)
      @collection_view_data = collection_view_data
      @collection_view.reloadData unless @collection_view.nil?
    end

    def collectionView(collection_view, numberOfItemsInSection:section)
      @collection_view_data.length
    end

    def collectionView(collection_view, cellForItemAtIndexPath:index_path)
      item = @collection_view_data[index_path.row]

      collection_view.dequeueReusableCellWithReuseIdentifier(
        @cell_id, forIndexPath:index_path).tap do |cell|

        cell.model = item if cell.respond_to?(:model=)
        cell.on_render if cell.respond_to?(:on_render)
        cell.apply_bindings if cell.respond_to?(:bindings)

        if using_rmq
          rmq.build(cell) unless cell.reused
        end
      end
    end

    def collectionView(view, didSelectItemAtIndexPath:index_path)
      cell = view.cellForItemAtIndexPath(index_path)
      self.on_select(cell, index_path) if self.respond_to?(:on_select)
    end

    protected

    def using_rmq
      Object.method_defined?(:rmq) && rmq.respond_to?(:stylesheet)
    end

  end

  module CollectionViewCell

    attr_accessor :model
    attr_reader :reused

    def prepareForReuse
      @reused = true
    end

  end
end