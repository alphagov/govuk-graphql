module PathTreeHelpers
  ALL_EDITION_COLUMNS = Set.new(%i[
    analytics_identifier
    auth_bypass_ids
    base_path
    content_store
    created_at
    description
    details
    document_id
    document_type
    first_published_at
    id
    last_edited_at
    last_edited_by_editor_id
    major_published_at
    phase
    public_updated_at
    published_at
    publishing_api_first_published_at
    publishing_api_last_edited_at
    publishing_app
    publishing_request_id
    redirects
    rendering_app
    routes
    schema_name
    state
    title
    update_type
    updated_at
    user_facing_version
  ]).freeze

  def self.build_paths(lookahead)
    paths = extract_paths(lookahead)
    reverse, forward = paths.reject(&:empty?).partition { it.last[:reverse] }
    [
      forward.map { build_path(it) },
      reverse.map { build_path(it) },
    ]
  end

  def self.build_path(raw_path)
    {
      path: raw_path[0...-1].map { it[:alias] || it[:type] },
      next: raw_path.last[:type],
      next_alias: raw_path.last[:alias] || raw_path.last[:type],
      columns: raw_path.last[:columns],
    }
  end

  def self.extract_paths(lookahead, current_path = [])
    [current_path].compact + lookahead.selections
                                        .filter { it.name == :links }
                                        .flat_map(&:selections)
                                        .filter { it.name == :links_of_type }
                                        .flat_map { extract_paths(it, current_path + [build_segment(it)]) }
  end

  def self.build_segment(selection)
    segment = {}
    segment = segment.merge(selection.arguments)
    selection.ast_nodes.map(&:alias) => [ selection_alias ]
    segment = segment.merge({ alias: selection_alias }) if selection_alias.present?
    segment.merge({ columns: (selection.selections.map(&:name).to_set & ALL_EDITION_COLUMNS).index_with(true) })
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

    # TODO: this can't tell the difference between parent_taxon and child_taxon (which is a reverse link of type parent_taxon)
    children_grouped_by_link_type = children
                                     .map { |child| nest(child, rows_by_parent) }
                                     .group_by { |child| child[:path].last }
    node.merge(
      links: children_grouped_by_link_type,
    )
  end
end
