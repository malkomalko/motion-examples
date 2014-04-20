module TvBarsCellStylesheet
  def tv_bars_cell_height
    80
  end

  def tv_bars_cell(st)
    # Style overall cell here
    st.background_color = color.random
  end

  def cell_label(st)
    st.color = color.black
  end
end
