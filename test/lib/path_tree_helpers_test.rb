# test/lib/path_tree_helpers_test.rb
require "ostruct"
require "minitest/autorun"
require_relative "../../lib/path_tree_helpers"
require_relative "../test_helper"

class PathTreeHelpersTest < Minitest::Test
  Selection = Data.define(:name, :arguments, :selections)
  def test_extract_paths
    lookahead = Minitest::Mock.new
    lookahead.expect :selections, [
      Selection.new(name: :links, arguments: {}, selections: [
        Selection.new(name: :links_of_type, arguments: { name: "person" }, selections: [
          Selection.new(name: :base_path, arguments: {}, selections: []),
          Selection.new(name: :title, arguments: {}, selections: []),
          Selection.new(name: :links, arguments: {}, selections: [
            Selection.new(name: :links_of_type, arguments: { name: "person", reverse: true }, selections: [
              Selection.new(name: :base_path, arguments: {}, selections: []),
              Selection.new(name: :title, arguments: {}, selections: []),
              Selection.new(name: :links, arguments: {}, selections: [
                Selection.new(name: :links_of_type, arguments: { name: "role" }, selections: [
                  Selection.new(name: :base_path, arguments: {}, selections: []),
                  Selection.new(name: :title, arguments: {}, selections: []),
                ]),
              ]),
            ]),
          ]),
        ]),
        Selection.new(name: :links_of_type, arguments: { name: "organisation" }, selections: [
          Selection.new(name: :base_path, arguments: {}, selections: []),
          Selection.new(name: :title, arguments: {}, selections: []),
        ]),
      ]),
    ]

    expected_paths = [
      [],
      [{ name: "person", columns: { base_path: true, title: true } }],
      [
        { name: "person", columns: { base_path: true, title: true } },
        { name: "person", reverse: true, columns: { base_path: true, title: true } },
      ],
      [
        { name: "person", columns: { base_path: true, title: true } },
        { name: "person", reverse: true, columns: { base_path: true, title: true } },
        { name: "role", columns: { base_path: true, title: true } },
      ],
      [
        { name: "organisation", columns: { base_path: true, title: true } },
      ],
    ]

    assert_equal expected_paths, PathTreeHelpers.extract_paths(lookahead)
  end

  def test_nest_results
    rows = [
      { id_path: [1], path: [], content_id: "root" },
      { id_path: [1, 2], path: %w[link_type], content_id: "link1" },
      { id_path: [1, 2, 3], path: %w[link_type person], content_id: "person1" },
      { id_path: [1, 2, 4], path: %w[link_type person], content_id: "person2" },
      { id_path: [1, 2, 5], path: %w[link_type role], content_id: "role1" },
    ]

    expected_tree = {
      id_path: [1],
      path: [],
      content_id: "root",
      links: {
        "link_type" => [
          {
            id_path: [1, 2],
            path: %w[link_type],
            content_id: "link1",
            links: {
              "person" => [
                { id_path: [1, 2, 3], path: %w[link_type person], content_id: "person1" },
                { id_path: [1, 2, 4], path: %w[link_type person], content_id: "person2" },
              ],
              "role" => [
                { id_path: [1, 2, 5], path: %w[link_type role], content_id: "role1" },
              ],
            },
          },
        ],
      },
    }

    assert_equal expected_tree, PathTreeHelpers.nest_results(rows)
  end
end
