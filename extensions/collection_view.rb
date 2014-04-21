module RMExtensions
  module CollectionView

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def cell_class(cell_class)
        @cell_class = cell_class
      end

      def layout(layout)
        @layout = layout
      end

    end

    def viewDidLoad
      super

      @cell_class = self.class.instance_variable_get(:@cell_class)
      @cell_id = @cell_class.to_s
      @layout = self.class.instance_variable_get(:@layout)

      setup_collection_view

      self.on_render if self.respond_to?(:on_render)
    end

    def setup_collection_view
      layout = @layout || UICollectionViewFlowLayout

      @collection_view = UICollectionView.alloc.initWithFrame(
        self.view.frame, collectionViewLayout:layout.alloc.init)

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
      collection_view.dequeueReusableCellWithReuseIdentifier(
        @cell_id, forIndexPath:index_path).tap do |cell|
        item = @collection_view_data[index_path.row]
        cell.model = item if cell.respond_to?(:model=)
        if using_rmq
          rmq.build(cell) unless cell.reused
        end
        cell.on_render if cell.respond_to?(:on_render)
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

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def cell_id(cell_id)
        @cell_id = cell_id
      end

      def content_view(&block)
        @content_view = block
      end

    end

    attr_accessor :model
    attr_reader :reused

    def rmq_build
      return unless Object.method_defined?(:rmq)

      @cell_id = self.class.instance_variable_get(:@cell_id)
      @content_view = self.class.instance_variable_get(:@content_view)
      rmq(self).apply_style @cell_id.to_sym
      self.instance_eval(&@content_view) unless @content_view.nil?
    end

    def add(klass, opts = {})
      style_tag = "#{@cell_id}_#{opts[:named].to_s}"
      sub_view = rmq(self.contentView).append(klass, style_tag)
      self.instance_variable_set("@#{opts[:named]}", sub_view)
    end

    def prepareForReuse
      @reused = true
    end

  end
end