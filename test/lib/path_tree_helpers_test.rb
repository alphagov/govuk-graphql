# test/lib/path_tree_helpers_test.rb
require "ostruct"
require "minitest/autorun"
require_relative "../../lib/path_tree_helpers"

class PathTreeHelpersTest < Minitest::Test
  def test_extract_paths
    lookahead = Minitest::Mock.new
    lookahead.expect :selections, [
      OpenStruct.new(name: :links, selections: [
        OpenStruct.new(name: :person, selections: [
          OpenStruct.new(name: :links, selections: [
            OpenStruct.new(name: :role, selections: [])
          ])
        ]),
        OpenStruct.new(name: :organisation, selections: [
          OpenStruct.new(name: :links, selections: [
            OpenStruct.new(name: :employees, selections: [])
          ])
        ])
      ])
    ]

    expected_paths = [
      [],
      %i[person],
      %i[person role],
      %i[organisation],
      %i[organisation employees]
    ]

    assert_equal expected_paths, PathTreeHelpers.extract_paths(lookahead)
  end

  def test_nest_results
    rows = [
      { path: [], content_id: "root" },
      { path: %w[links], content_id: "link1" },
      { path: %w[links person], content_id: "person1" },
      { path: %w[links role], content_id: "role1" }
    ]

    expected_tree = {
      node: { path: [], content_id: "root" },
      children: {
        "links" => [{
          node: { path: %w[links], content_id: "link1" },
          children: {
            "person" => [{
              node: { path: %w[links person], content_id: "person1" },
              children: {}
            }],
            "role" => [{
              node: { path: %w[links role], content_id: "role1" },
              children: {}
            }]
          }
        }]
      }
    }

    assert_equal expected_tree, PathTreeHelpers.nest_results(rows)
  end
end
