module RMExtensions
  module CollectionView

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def cell_class(cell_class)
        @cell_class = cell_class
      end

      def cell_id(cell_id)
        @cell_id = cell_id
      end

      def cell_margin(cell_margin)
        @cell_margin = cell_margin
      end

    end

    def viewDidLoad
      super

      @cell_class = self.class.instance_variable_get(:@cell_class)
      @cell_class ||= UICollectionViewCell
      @cell_id = self.class.instance_variable_get(:@cell_id)
      @cell_margin = self.class.instance_variable_get(:@cell_margin)
      @cell_margin ||= 0

      setup_collection_view

      self.on_render if self.respond_to?(:on_render)
    end

    def setup_collection_view
      layout = UICollectionViewFlowLayout.alloc.init

      @collection_view = UICollectionView.alloc.initWithFrame(
        self.view.frame, collectionViewLayout:layout)
      @collection_view.styleId = @cell_id
      @collection_view.dataSource = self
      @collection_view.delegate = self
      @collection_view.registerClass(
        @cell_class, forCellWithReuseIdentifier:@cell_id)
      self.view.addSubview(@collection_view)

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
      cell = collection_view.dequeueReusableCellWithReuseIdentifier(
        @cell_id, forIndexPath:index_path)
      cell.model = @collection_view_data[index_path.row]
      cell.styleClass = 'cell'
      cell
    end

    def collectionView(collection_view, layout:layout,
                       insetForSectionAtIndex:section)
      UIEdgeInsetsMake(@cell_margin, @cell_margin, @cell_margin, @cell_margin)
    end

  end
end