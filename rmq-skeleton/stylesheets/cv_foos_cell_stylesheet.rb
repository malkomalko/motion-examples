module CvFoosCellStylesheet
  def cell_size
    {w: 96, h: 96}
  end

  def cv_foos_cell(st)
    st.frame = cell_size
    st.background_color = color.random

    # Style overall view here
  end

end
