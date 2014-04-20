class NSArray

  def move(from, to)
    insert(to, delete_at(from))
  end

end