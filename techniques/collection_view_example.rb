class FooController < UIViewController

  include RMExtensions::CollectionView

  cell_class FooCell

  def on_render
    SomeClass.some_async_fetch do |err, res|
      self.collection_view_data = res
    end
  end

  def on_select(cell, index_path)
    ap ['on_select', cell]
  end

end

class FooCell < UICollectionViewCell

  include RMExtensions::CollectionViewCell

  cell_id 'foo_cell'

  content_view do
    add UILabel, named: :welcome
  end

  def on_render
    @welcome.get.text = model.text
  end

end

class CollectionViewsStylesheet < ApplicationStylesheet

  def setup
    @margin = 20
    @foo_cell_size = {w: 200, h: 200}
  end

  def collection_view(st, cell_size)
    st.view.contentInset = [@margin, @margin, @margin, @margin]

    st.view.collectionViewLayout.tap do |cl|
      cl.itemSize = [cell_size[:w], cell_size[:h]]
      cl.scrollDirection = UICollectionViewScrollDirectionVertical
      cl.headerReferenceSize = [0, 0]
      cl.minimumInteritemSpacing = @margin
      cl.minimumLineSpacing = @margin
    end
  end

  def collection_foo_cell(st)
    full_screen(st)
    collection_view(st, @foo_cell_size)
    st.background_color = color.white
  end

  def foo_cell(st)
    st.frame = @foo_cell_size
    st.background_color = color.random
  end

  def foo_cell_welcome(st)
    ...
  end

end