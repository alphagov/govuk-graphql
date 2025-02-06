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
      { id_path: [1], path: [], content_id: "root" },
      { id_path: [1, 2], path: %w[link_type], content_id: "link1" },
      { id_path: [1, 2, 3], path: %w[link_type person], content_id: "person1" },
      { id_path: [1, 2, 4], path: %w[link_type person], content_id: "person2" },
      { id_path: [1, 2, 5], path: %w[link_type role], content_id: "role1" }
    ]

    expected_tree = {
      id_path: [1], path: [], content_id: "root",
      links: {
        "link_type" => [
          {
            id_path: [1, 2], path: ["link_type"], content_id: "link1",
            links: {
              "person" => [
                { id_path: [1, 2, 3], path: ["link_type", "person"], content_id: "person1" },
                { id_path: [1, 2, 4], path: ["link_type", "person"], content_id: "person2" }
              ],
              "role" => [
                { id_path: [1, 2, 5], path: ["link_type", "role"], content_id: "role1" }
              ]
            }
          }
        ]
      }
    }


    assert_equal expected_tree, PathTreeHelpers.nest_results(rows)
  end
end
