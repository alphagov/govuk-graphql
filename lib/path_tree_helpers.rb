module PathTreeHelpers
  def self.extract_paths(lookahead, current_path = [])
    [ current_path ] + lookahead.selections
                                .filter { it.name == :links }
                                .flat_map(&:selections)
                                .flat_map { extract_paths(it, current_path + [ it.name ]) }
  end

  # AI generated slop code
  def self.nest_results(rows)
    root = { node: nil, children: {} }

    rows.each do |row|
      if row[:path].empty?
        root[:node] = row
        next
      end

      node = root
      row[:path].each_with_index do |path_part, index|
        node[:children][path_part] ||= []
        if index == row[:path].length - 1
          node[:children][path_part] << { node: row, children: {} }
        else
          existing_node = node[:children][path_part].find { |child| child[:node][:path] == row[:path][0..index] }
          if existing_node
            node = existing_node
          else
            new_node = { node: { path: row[:path][0..index] }, children: {} }
            node[:children][path_part] << new_node
            node = new_node
          end
        end
      end
    end

    root
  end
end
