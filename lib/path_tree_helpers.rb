module PathTreeHelpers
  def self.extract_paths(lookahead, current_path = [])
    [ current_path ] + lookahead.selections
                                .filter { it.name == :links }
                                .flat_map(&:selections)
                                .flat_map { extract_paths(it, current_path + [ it.name ]) }
  end

  def self.nest_results(rows)
    # Each row is a hash with an :id_path key, which is a number array like [31,41,59,26,53,58].
    # The parent of each row is the :id_path with the last element removed
    rows_by_parent = rows.group_by { |row| row[:id_path][0...-1] }

    # The root is the row with an empty parent
    roots = rows_by_parent[[]]
    raise "expected to find exactly one root" unless roots.size == 1

    root = roots.first

    nest(root, rows_by_parent)
  end

  def self.nest(node, rows_by_parent)
    children = rows_by_parent[node[:id_path]]
    return node unless children
    children_grouped_by_link_type = children
                                     .map { |child| nest(child, rows_by_parent) }
                                     .group_by { |child| child[:path].last }
    node.merge(
      links: children_grouped_by_link_type
    )
  end
end
