class CvFoosCell < UICollectionViewCell 
  attr_reader :reused

  def rmq_build
    rmq(self).apply_style :cv_foos_cell

    rmq(self.contentView).tap do |q|
      # Add your subviews, init stuff here
      # @foo = q.append(UILabel, :foo).get
    end
  end

  def prepareForReuse
    @reused = true
  end

end
